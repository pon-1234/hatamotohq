# frozen_string_literal: true

class Messages::MessageBuilder
  attr_reader :message

  # sender: LineFriend, User or nil means Bot
  # channel: destination
  # body: message body
  def initialize(sender, channel, body)
    @body = body
    @channel = channel
    @sender = sender
  end

  def perform
    @message = @channel.messages.build(message_params)
    @message.sender = @sender
    @message.save!
    @message
  end

  private
    def from
      return @body[:from] if @body[:from].present?
      return 'friend' if @sender&.is_a?(LineFriend)
      return 'user' if @sender&.is_a?(User)
      'bot'
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
        timestamp: @body[:timestamp],
        reply_token: @body[:replyToken],
        text: text
      }
    end
end
