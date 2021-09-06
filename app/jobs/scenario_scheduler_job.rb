# frozen_string_literal: true

class ScenarioSchedulerJob < ApplicationJob
  queue_as :default

  def perform(channel_id, scenario_id)
    @channel = Channel.find(channel_id)
    @scenario = Scenario.find(scenario_id)
    messages = @scenario.scenario_messages.ordered
    return if messages.empty?
    messages.each do |message|
      schedule(message)
    end
  end

  def schedule(message)
    if message.is_initial?
      deliver_now(message)
    end

    deliver_later(message)
  end

  def deliver_now(message)
    payload = {
      channel_id: @channel.id,
      messages: [message.content]
    }
    p '------'
    p payload
    PushMessageToLineJob.perform_later(payload)
  end

  def deliver_later(message)
  end
end
