# frozen_string_literal: true

class Postback::SendTextMessageHandler < Postback::BaseHandler
  def initialize(friend, content, reply_token)
    super
    @reply_token = reply_token
  end

  def perform
    messages = [{ type: 'text', text: @content['text'] }]
    # Rebuild payload
    payload = {
      channel_id: @friend.channel.id,
      reply_token: @reply_token,
      messages: messages
    }
    PushMessageToLineJob.perform_later(payload)
  end
end
