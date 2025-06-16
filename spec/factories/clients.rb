# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id            :bigint           not null, primary key
#  name          :string
#  phone_number  :string
#  address       :string
#  status        :string           default("active")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  agency_id     :bigint
#  gauth_visible :boolean          default(FALSE)
#
# Indexes
#
#  index_clients_on_agency_id  (agency_id)
#
# Foreign Keys
#
#  fk_rails_...  (agency_id => agencies.id)
#
FactoryBot.define do
  factory :client do
    name { 'sample name' }
    phone_number { 1234567890 }
    address { 'sample address' }
    status { 'active' }
  end
end
