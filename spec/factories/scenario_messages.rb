# frozen_string_literal: true

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