# frozen_string_literal: true

class PushMessageToLineJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :default
  MAX_MSG_IN_REQUEST = 5

  def perform(payload)
    @channel = Channel.find(payload[:channel_id])
    @line_account = @channel.line_account
    @reply_token = payload[:reply_token]
    messages = payload[:messages]
    # Send using reply token
    if @reply_token.present?
      # Get the first 5 messages to send using reply token
      reply_messages = messages.shift(MAX_MSG_IN_REQUEST)
      send_reply_messages(reply_messages)
    end
    # Send remaining message
    send_messages(messages)
  end

  def send_reply_messages(messages)
    return if messages.empty?
    success = LineApi::ReplyMessage.new(@line_account).perform(messages, @reply_token)
    return unless success
    store_messages(messages)
  end

  def send_messages(messages)
    messages.in_groups_of(MAX_MSG_IN_REQUEST, false) do |grouped_messages|
      success = LineApi::PushMessage.new(@line_account).perform(grouped_messages, @channel.line_friend.line_user_id)
      return unless success
      store_messages(grouped_messages)
    end
  end

  def store_messages(messages)
    messages.each do |message|
      # Normalized message params
      message_params = {
        replyToken: @reply_token,
        message: message.try(:with_indifferent_access),
        timestamp: Time.zone.now.to_i * 1000
      }
      Messages::MessageBuilder.new(nil, @channel, message_params).perform
    end
  end

  def normalize_message(message)
    message_type = message[:type]
    return message if message_type.eql?('message')

    if message_type.eql?('flex') && message[:id].present?
      flex_message_id = message[:id]
      flex_message = FlexMessage.find_by_id(flex_message_id)
      if flex_message.present?
        line_content = flex_message.json_message
        line_content['id'] = flex_message_id
      end
    end
    # TODO

    message
  end
end
