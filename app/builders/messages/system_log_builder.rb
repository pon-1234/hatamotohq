# frozen_string_literal: true

class Messages::SystemLogBuilder
  attr_reader :message

  def initialize(channel)
    @channel = channel
    init_message
  end

  def perform_follow
    @message.text = '【フォローされました】'
    @message.save!
    @message
  end

  def perform_unfollow
    @message.text = '【アンフォローされました】'
    @message.save!
    @message
  end

  def perform_broadcast(broadcast)
    @message.text = "メッセージが配信されました：#{broadcast.title}"
    @message.save!
    @message
  end

  private
    def init_message
      @message = Message.new(channel: @channel)
      @message.type = :log
      @message.from = :system
      @message.timestamp = (Time.now.to_f * 1000).to_i
    end
end
