# frozen_string_literal: true

FactoryBot.define do
  factory :message_type do
    sequence(:name) { |n| "Message Type #{n}" }
    title { 'Test Message Type' }
  end
end