# frozen_string_literal: true

class ScenarioSchedulerJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :default
  include User::MessagesHelper

  def perform(channel_id, scenario_id)
    @channel = Channel.find(channel_id)
    @scenario = Scenario.find(scenario_id)
    messages = @scenario.scenario_messages.enabled.ordered
    return if messages.empty?
    save_scenario_started_log
    messages.each do |message|
      schedule(message)
    end
    schedule_after_action(messages.last)
  end

  private
    def schedule(message)
      if message.is_initial?
        deliver_now(message)
      else
        create_message_event(message, deliver_time_for(message))
      end
    end

    def deliver_now(message)
      normalized = Normalizer::MessageNormalizer.new(message.content).perform
      if contain_survey_action?(normalized)
        normalized = normalize_messages_with_survey_action(@channel, normalized)
      end
      payload = {
        channel_id: @channel.id,
        messages: [normalized]
      }
      PushMessageToLineJob.perform_now(payload)
    end

    # If last message is initial message then perform after action immediately
    # Otherwise, create a new scenario event
    def schedule_after_action(last_message)
      if last_message.is_initial?
        ActionHandlerJob.perform_now(@channel.line_friend, @scenario.after_action['data'])
        save_scenario_ended_log
      else
        schedule_at = deliver_time_for(last_message) + 1.second
        step = last_message.step + 1
        create_after_action_event(schedule_at, step)
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
        order: message.step,
        status: 'queued'
      )
      scenario_event.save!
    end

    def create_after_action_event(schedule_at, step)
      scenario_event = ScenarioEvent.new(
        line_account: @channel.line_account,
        scenario: @scenario,
        channel: @channel,
        type: 'after_action',
        content: @scenario.after_action['data'],
        schedule_at: schedule_at,
        order: step,
        status: 'queued',
        is_last: true
      )
      scenario_event.save!
    end

    def save_scenario_started_log
      Messages::SystemLogBuilder.new(@channel).perform_scenario_start(@scenario)
    end

    def save_scenario_ended_log
      Messages::SystemLogBuilder.new(@channel).perform_scenario_end(@scenario)
    end
end
