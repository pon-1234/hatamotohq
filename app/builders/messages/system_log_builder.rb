# frozen_string_literal: true

class Messages::SystemLogBuilder
  attr_reader :message

  def initialize(channel)
    @channel = channel
    init_message
  end

  def perform_follow
    @message.text = I18n.t('messages.logs.follow')
    @message.save!
    @message
  end

  def perform_unfollow
    @message.text = I18n.t('messages.logs.unfollow')
    @message.save!
    @message
  end

  def perform_broadcast(broadcast)
    @message.text = I18n.t('messages.logs.broadcast', { title: broadcast.title })
    @message.save!
    @message
  end

  def perform_scenario_start(scenario)
    @message.text = I18n.t('messages.logs.scenario_start', { title: scenario.title })
    @message.save!
    @message
  end

  def perform_scenario_end(scenario)
    @message.text = I18n.t('messages.logs.scenario_end', { title: scenario.title })
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
