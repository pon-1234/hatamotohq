# frozen_string_literal: true

class PushMessageToLineJob < ApplicationJob
  queue_as :default

  def perform(payload)
    line_account = LineAccount.find(payload[:line_account_id])
    messages = payload[:messages]
    # Get the first 3 messages to send using reply token
    reply_messages = messages.shift(3)
    send_reply_messages(line_account, reply_messages, payload[:reply_token])

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
    LineApi::PostMessageReply.new(
      line_account.line_channel_id,
      line_account.line_channel_secret,
      message_body,
      reply_token
    ).perform
  end
end
