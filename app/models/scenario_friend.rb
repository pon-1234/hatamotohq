# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_friends
#
#  id             :bigint           not null, primary key
#  scenario_id    :bigint           not null
#  line_friend_id :bigint           not null
#  status         :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_scenario_friends_on_line_friend_id  (line_friend_id)
#  index_scenario_friends_on_scenario_id     (scenario_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_friend_id => line_friends.id)
#  fk_rails_...  (scenario_id => scenarios.id)
#
class ScenarioFriend < ApplicationRecord
  belongs_to :scenario
  belongs_to :line_friend

  enum status: { running: 'running', done: 'done' }
end
