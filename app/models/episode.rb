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
  belongs_to :reminder
end
