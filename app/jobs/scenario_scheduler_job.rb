# frozen_string_literal: true

class ScenarioSchedulerJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :default

  def perform(channel_id, scenario_id)
    @channel = Channel.find(channel_id)
    @scenario = Scenario.find(scenario_id)
    messages = @scenario.scenario_messages.enabled.ordered
    return if messages.empty?
    messages.each do |message|
      schedule(message)
    end
    schedule_after_action(messages.last)
  end

  def schedule(message)
    if message.is_initial?
      deliver_now(message)
    else
      schedule_delay_message(message)
    end
  end

  def deliver_now(message)
    normalized = Normalizer::MessageNormalizer.new(message.content).perform
    payload = {
      channel_id: @channel.id,
      messages: [normalized]
    }
    PushMessageToLineJob.perform_later(payload)
  end

  def schedule_delay_message(message)
    create_message_event(message, deliver_time_for(message))
  end

  def schedule_after_action(last_message)
    # If last message is initial message then perform after action immediately
    # Otherwise, create a new scenario event
    if last_message.is_initial?
      ActionHandlerJob.perform_now(@channel.line_friend, @scenario.after_action['data'])
    else
      schedule_at = deliver_time_for(last_message) + 1.second
      order = last_message.order + 1
      create_after_action_event(schedule_at, order)
    end
  end

  def deliver_time_for(message)
    date = message.date
    time = message.time.to_time
    case @scenario.mode
    when 'time'
      (Time.zone.today + message.date).change({ hour: time.hour, minute: time.min, second: 0 })
    when 'elapsed_time'
      Time.zone.now.change({ second: 0 }) + date.day + time.hour.hour + time.min.minute
    end
  end

  def create_message_event(message, schedule_at)
    scenario_event = ScenarioEvent.new(
      line_account: @channel.line_account,
      scenario: @scenario,
      channel: @channel,
      scenario_message: message,
      type: 'message',
      content: message.content,
      schedule_at: schedule_at,
      order: message.order,
      status: 'queued'
    )
    scenario_event.save!
  end

  def create_after_action_event(schedule_at, order)
    scenario_event = ScenarioEvent.new(
      line_account: @channel.line_account,
      scenario: @scenario,
      channel: @channel,
      type: 'after_action',
      content: @scenario.after_action['data'],
      schedule_at: schedule_at,
      order: order,
      status: 'queued'
    )
    scenario_event.save!
  end
end
