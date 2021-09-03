# frozen_string_literal: true

class PushMessageToLineJob < ApplicationJob
  queue_as :default
  MAX_MSG_IN_REQUEST = 5

  def perform(payload)
    @line_account = LineAccount.find(payload[:line_account_id])
    @channel = Channel.find(payload[:channel_id])
    @messages = payload[:messages]
    @reply_token = payload[:reply_token]

    # Send using reply token
    if @reply_token.present?
      # Get the first 5 messages to send using reply token
      reply_messages = @messages.shift(MAX_MSG_IN_REQUEST)
      send_reply(reply_messages)
    end

    # Send remaining message
    send(@messages)
  end

  def send_reply(messages)
    message_content_arr = []
    messages.each do |message|
      message_content = message[:message]
      message_content_arr << message_content
    end

    return if message_content_arr.empty?
    success = LineApi::PostMessageReply.new(
      @line_account.line_channel_id,
      @line_account.line_channel_secret,
      message_content_arr,
      @reply_token
    ).perform
    return unless success
    store_messages(message_content_arr)
  end

  def send(messages)
    messages.in_groups_of(MAX_MSG_IN_REQUEST, false) do |grouped_messages|
      message_content_arr = []
      grouped_messages.each do |message|
        message_content = message[:message]
        message_content_arr << message_content
      end

      return if message_content_arr.empty?
      success = LineApi::PostMessagePush.new(
        @line_account.line_channel_id,
        @line_account.line_channel_secret,
        message_content_arr,
        @channel.line_friend.line_user_id
      ).perform
      return unless success
      store_messages(message_content_arr)
    end
  end

  def store_messages(message_content_arr)
    message_content_arr.each do |message_content|
      # Normalized message params
      message_params = {
        replyToken: @reply_token,
        message: {
          type: message_content[:type],
          line_content: message_content,
          timestamp: Time.now.to_i
        }
      }
      mb = Messages::MessageBuilder.new(nil, @channel, message_params)
      message = mb.perform
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
