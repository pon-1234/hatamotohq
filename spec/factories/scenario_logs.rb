# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_logs
#
#  id             :bigint           not null, primary key
#  scenario_id    :bigint           not null
#  line_friend_id :bigint           not null
#  status         :string(255)
#  start_at       :datetime
#  end_at         :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_scenario_logs_on_line_friend_id  (line_friend_id)
#  index_scenario_logs_on_scenario_id     (scenario_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_friend_id => line_friends.id)
#  fk_rails_...  (scenario_id => scenarios.id)
#
FactoryBot.define do
  factory :scenario_log do
    scenario { nil }
    line_friend { nil }
    status { 'MyString' }
    start_at { '2022-02-14 15:40:03' }
    end_at { '2022-02-14 15:40:03' }
  end
end
