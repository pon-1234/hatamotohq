# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id           :bigint           not null, primary key
#  name         :string(255)
#  phone_number :string(255)
#  address      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :client do
  end
end
