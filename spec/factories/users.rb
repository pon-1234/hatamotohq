# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  authentication_token   :string
#  pubsub_token           :string
#  name                   :string
#  company_name           :string
#  phone_number           :string
#  address                :string
#  note                   :text
#  status                 :string           default("active")
#  role                   :string
#  client_id              :bigint
#
# Indexes
#
#  index_users_on_authentication_token  (authentication_token) UNIQUE
#  index_users_on_client_id             (client_id)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :user do
    transient do
      is_admin { true }
    end
    sequence(:email) { |n| "staff#{n}@example.com" }
    password { 'admin1234' }
    password_confirmation { 'admin1234' }
    phone_number { 1234567890 }
    address { 'sample address' }
    role { is_admin ? 'admin' : 'staff' }
  end
end
