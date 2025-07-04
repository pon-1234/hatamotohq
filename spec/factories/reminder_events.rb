# frozen_string_literal: true

# == Schema Information
#
# Table name: reminder_events
#
#  id           :bigint           not null, primary key
#  reminding_id :bigint
#  episode_id   :bigint
#  schedule_at  :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  status       :string
#  is_last      :boolean          default(FALSE)
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
FactoryBot.define do
  factory :reminder_event do
  end
end
