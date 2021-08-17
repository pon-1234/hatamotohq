FactoryBot.define do
  sequence(:user_email) { |n| "example#{n}@example.com" }
  factory :user do
    email { FactoryBot.generate :user_email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
