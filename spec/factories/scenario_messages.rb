# frozen_string_literal: true

# == Schema Information
#
# Table name: scenario_messages
#
#  id              :bigint           not null, primary key
#  scenario_id     :bigint
#  status          :string           default("disabled")
#  name            :string
#  content         :json
#  message_type_id :integer
#  date            :integer
#  time            :string
#  is_initial      :boolean          default(TRUE)
#  step            :integer
#  order           :integer
#  pause           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  deleted_at      :datetime
#
# Indexes
#
#  index_scenario_messages_on_scenario_id  (scenario_id)
#
# Foreign Keys
#
#  fk_rails_...  (scenario_id => scenarios.id)
#
FactoryBot.define do
  factory :scenario_message do
    scenario
    message_type_id { 1 }
    step { 0 }
    date { 0 }
    time { '00:00' }
    content { { type: 'text', text: 'Test message' } }
    status { 'enabled' }
    is_initial { false }
  end
end
