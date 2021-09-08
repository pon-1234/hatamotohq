# frozen_string_literal: true

class ScenarioSchedulerJob < ApplicationJob
  queue_as :default

  def perform(channel_id, scenario_id)
    @channel = Channel.find(channel_id)
    @scenario = Scenario.find(scenario_id)
    messages = @scenario.scenario_messages.enabled.ordered
    return if messages.empty?
    messages.each do |message|
      schedule(message)
    end
  end

  def schedule(message)
    if message.is_initial?
      deliver_now(message)
    else
      deliver_later(message)
    end
  end

  def deliver_now(message)
    payload = {
      channel_id: @channel.id,
      messages: [message.content]
    }
    PushMessageToLineJob.perform_later(payload)
  end

  def deliver_later(message)
    time = message.time.to_time
    case @scenario.mode
    when 'date'
      schedule_at = (Time.zone.today + message.date).change({ hour: time.hour, min: time.min })
      create_scenario_event(message, schedule_at)
    when 'elapsed_time'
      schedule_at = Time.zone.now + date.day + time.hour.hour + time.min.min
      byebug
      create_scenario_event(message, schedule_at)
    end
  end

  def create_scenario_event(message, schedule_at)
    scenario_event = ScenarioEvent.new(
      line_account: @channel.line_account,
      scenario: @scenario,
      channel: @channel,
      scenario_message: message,
      schedule_at: schedule_at,
      order: message.order,
      status: 'queued'
    )
    scenario_event.save!
  end
end
