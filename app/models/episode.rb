# frozen_string_literal: true

# == Schema Information
#
# Table name: episodes
#
#  id          :bigint           not null, primary key
#  reminder_id :bigint
#  is_initial  :boolean
#  date        :integer
#  time        :string(255)
#  actions     :json
#  messages    :json
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_episodes_on_reminder_id  (reminder_id)
#
# Foreign Keys
#
#  fk_rails_...  (reminder_id => reminders.id)
#
class Episode < ApplicationRecord
  belongs_to :reminder, counter_cache: true
  has_many :reminder_events

  # Scope
  scope :ordered, -> { order(is_initial: :desc, date: :desc, time: :desc) }

  before_save do
    self.is_initial = true if (self.date == 0) && self.time.eql?('00:00')
  end
end
