# frozen_string_literal: true

# == Schema Information
#
# Table name: reminder_events
#
#  id           :bigint           not null, primary key
#  reminding_id :bigint
#  episode_id   :bigint
#  status       :string(255)
#  schedule_at  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_reminder_events_on_episode_id    (episode_id)
#  index_reminder_events_on_reminding_id  (reminding_id)
#
# Foreign Keys
#
#  fk_rails_...  (episode_id => episodes.id)
#  fk_rails_...  (reminding_id => remindings.id)
#
class ReminderEvent < ApplicationRecord
  include User::MessagesHelper
  belongs_to :reminding
  belongs_to :episode

  # Scope
  enum status: { queued: 'queued', sending: 'sending', done: 'done', cancelled: 'cancelled', error: 'error' }
  scope :before, ->(time) { where('schedule_at <= ?', time) }

  def invoke
    deliver_messages
    deliver_actions
    execute_after_deliver
  end

  def cancel
    self.update_columns(status: :cancelled)
  end

  private
    def deliver_messages
      nomalized_messages = []
      self.episode.messages.each do |message|
        nomalized_messages << Normalizer::MessageNormalizer.new(message.try(:content) || message['content']).perform
      end
      if contain_survey_action?(nomalized_messages)
        nomalized_messages = normalize_messages_with_survey_action(self.reminding.channel, nomalized_messages)
      end
      payload = {
        channel_id: self.reminding.channel_id,
        messages: nomalized_messages
      }
      PushMessageToLineJob.perform_now(payload)
    end

    def deliver_actions
      ActionHandlerJob.perform_now(self.reminding.channel.line_friend, self.episode.actions['data'])
    end

    def execute_after_deliver
      self.status = :done
      self.save!
    end
end
