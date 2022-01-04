# frozen_string_literal: true

# == Schema Information
#
# Table name: agencies
#
#  id                     :bigint           not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)      not null
#  address                :string(255)
#  phone_number           :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_agencies_on_email                 (email) UNIQUE
#  index_agencies_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :agency do
    sequence(:email) {|n| "agencytest#{n}@example.com"}
    password {'admin1234'}
    password_confirmation {'admin1234'}
    name {'sample name'}
    address {'sample address'}
    phone_number {1234567890}    
  end
end
