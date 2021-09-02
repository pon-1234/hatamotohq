# frozen_string_literal: true

class Messages::MessageBuilder
  attr_reader :message

  def initialize(sender, channel, body)
    @body = body
    @channel = channel
    @sender = sender
  end

  def perform
    @message = @channel.messages.build(message_params)
    @message.save
    @message
  end

  private
    def from
      'friend'
    end

    def text
      @body[:message][:type].eql?('text') ? @body[:message][:text] : nil
    end

    def message_params
      {
        sender: @sender,
        from: from,
        type: @body[:message][:type],
        line_message_id: @body[:message][:id],
        line_content: @body[:message],
        line_timestamp: @body[:timestamp],
        line_reply_token: @body[:replyToken],
        text: text
      }
    end
end
