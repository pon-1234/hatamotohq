# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_events
#
#  id                  :bigint           not null, primary key
#  line_account_id     :bigint
#  scenario_id         :bigint
#  scenario_message_id :bigint
#  type                :string(255)
#  content             :json
#  channel_id          :bigint
#  schedule_at         :datetime
#  order               :integer
#  status              :string(255)
#  is_last             :boolean          default(FALSE)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_scenario_events_on_channel_id           (channel_id)
#  index_scenario_events_on_line_account_id      (line_account_id)
#  index_scenario_events_on_scenario_id          (scenario_id)
#  index_scenario_events_on_scenario_message_id  (scenario_message_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (scenario_id => scenarios.id)
#  fk_rails_...  (scenario_message_id => scenario_messages.id)
#
require 'rails_helper'

RSpec.describe ScenarioEvent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
