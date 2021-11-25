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
  enum status: { active: 'active', cancelled: 'cancelled' }

  after_create do
    ReminderSchedulerJob.perform_later(self.id)
  end

  def cancel
    self.reminder_events.destroy_all
    self.status = :cancelled
    self.save
  end
end
