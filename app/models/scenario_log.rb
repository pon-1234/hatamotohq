# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_logs
#
#  id             :bigint           not null, primary key
#  scenario_id    :bigint           not null
#  line_friend_id :bigint           not null
#  status         :string
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
class ScenarioLog < ApplicationRecord
  belongs_to :scenario
  belongs_to :line_friend

  enum status: { running: 'running', done: 'done' }
end
