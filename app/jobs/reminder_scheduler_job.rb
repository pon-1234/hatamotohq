# frozen_string_literal: true

class ReminderSchedulerJob < ApplicationJob
  queue_as :default
  include User::MessagesHelper

  def perform(reminding_id)
    @reminding = Reminding.find_by_id(reminding_id)
    return unless @reminding.present?
    @channel = @reminding.channel

    reminder = @reminding.reminder
    episodes = reminder.episodes
    episodes.each_with_index do |episode, index|
      schedule(episode, index == episodes.length - 1)
    end
  end

  private
    def schedule(episode, is_last)
      if episode.is_initial?
        deliver_now(episode, is_last)
      else
        create_reminder_event(episode, deliver_time_for(episode), :queued, is_last)
      end
    end

    def deliver_now(episode, is_last)
      deliver_messages(episode)
      deliver_actions(episode)
      create_reminder_event(episode, Time.zone.now, :done, is_last)
      @reminding.finish
    end

    def deliver_messages(episode)
      nomalized_messages = []
      episode.messages.each do |message|
        nomalized_messages << Normalizer::MessageNormalizer.new(message.try(:content) || message['content']).perform
      end
      if contain_survey_action?(nomalized_messages)
        nomalized_messages = normalize_messages_with_survey_action(@channel, nomalized_messages)
      end
      payload = {
        channel_id: @channel.id,
        messages: nomalized_messages
      }
      PushMessageToLineJob.perform_now(payload)
    end

    def deliver_actions(episode)
      ActionHandlerJob.perform_now(@channel.line_friend, episode.actions['data'])
    end

    def create_reminder_event(episode, schedule_at, status, is_last)
      reminder_event = ReminderEvent.new(
        reminding: @reminding,
        episode_id: episode.id,
        schedule_at: schedule_at,
        status: status,
        is_last: is_last
      )
      reminder_event.save!
    end


    def deliver_time_for(episode)
      goal = @reminding.goal
      date = episode.date
      time = episode.time.to_time
      (goal - date).change({ hour: time.hour, minute: time.min, second: 0 })
    end
end
