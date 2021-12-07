# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)      default(""), not null
#  role                   :string(255)
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)
#  company_name           :string(255)
#  phone_number           :string(255)
#  address                :string(255)
#  note                   :text(65535)
#  status                 :string(255)      default("active")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string(255)
#  pubsub_token           :string(255)
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  sequence(:user_email) { |n| "example#{n}@example.com" }
  factory :user do
    email { FactoryBot.generate :user_email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
