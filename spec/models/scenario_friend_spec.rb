# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_friends
#
#  id             :bigint           not null, primary key
#  scenario_id    :bigint           not null
#  line_friend_id :bigint           not null
#  status         :string
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
require 'rails_helper'

RSpec.describe ScenarioFriend, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
