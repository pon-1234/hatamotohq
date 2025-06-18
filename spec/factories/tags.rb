# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "Tag #{n}" }
    line_account
    
    after(:build) do |tag|
      tag.folder ||= build(:folder, line_account: tag.line_account)
    end
  end
end