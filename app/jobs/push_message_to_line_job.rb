# frozen_string_literal: true

class PushMessageToLineJob < ApplicationJob
  queue_as :default

  def perform(payload)
    line_account = LineAccount.find(payload[:line_account_id])
    messages = payload[:messages]
    reply_token = payload[:reply_token]
    # Able to send using reply token
    if reply_token.present?
      # Get the first 3 messages to send using reply token
      reply_messages = messages.shift(3)
      send_reply_messages(line_account, reply_messages, reply_token)
    end

    # Send remaining message
    messages.each do |message|
      # TODO
    end
  end

  def send_reply_messages(line_account, messages, reply_token)
    message_body = []
    messages.each do |message|
      message_content = message[:data][:content][:line_content]
      message_body << message_content
    end

    return if message_body.empty?
    success = LineApi::PostMessageReply.new(
      line_account.line_channel_id,
      line_account.line_channel_secret,
      message_body,
      reply_token
    ).perform

    store_message() if success
  end

  def store_message()
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
