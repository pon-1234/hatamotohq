# frozen_string_literal: true

# == Schema Information
#
# Table name: remindings
#
#  id          :bigint           not null, primary key
#  channel_id  :bigint
#  reminder_id :bigint
#  goal        :datetime
#  status      :string(255)      default("active")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_remindings_on_channel_id   (channel_id)
#  index_remindings_on_reminder_id  (reminder_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#  fk_rails_...  (reminder_id => reminders.id)
#
class Reminding < ApplicationRecord
  belongs_to :channel
  belongs_to :reminder
  has_many :reminder_events

  # Validations
  validates :goal, presence: true

  # Scope
  enum status: { active: 'active', cancelled: 'cancelled', done: 'done' }

  after_create do
    ReminderSchedulerJob.perform_now(self.id)
    distribute_system_log
  end

  def cancel
    self.reminder_events.each { |_| _.cancel }
    self.status = :cancelled
    self.save!
  end

  def finish
    self.update_columns(status: :done)
  end

  private
    def distribute_system_log
      Messages::SystemLogBuilder.new(self.channel).perform_reminder(self.reminder)
    end
end
