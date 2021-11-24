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
    episodes.each do |episode|
      schedule(episode)
    end
  end

  private
    def schedule(episode)
      if episode.is_initial?
        deliver_now(episode)
      else
        create_reminder_event(episode, deliver_time_for(episode))
      end
    end

    def deliver_now(episode)
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


    def create_reminder_event(episode, schedule_at)
      reminder_event = ReminderEvent.new(
        reminding: @reminding,
        episode_id: episode.id,
        schedule_at: schedule_at,
        status: :queued
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
