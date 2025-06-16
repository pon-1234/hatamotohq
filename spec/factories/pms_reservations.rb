# frozen_string_literal: true

# == Schema Information
#
# Table name: pms_reservations
#
#  id                    :bigint           not null, primary key
#  line_friend_id        :bigint           not null
#  agency_booking_number :string
#  agency_code           :string
#  agency_name           :string
#  agency_plan_code      :string
#  agency_plan_name      :string
#  booking_date          :string
#  booking_time          :string
#  charge_claimed        :integer
#  charge_total          :integer
#  charge_type           :string
#  check_in_date         :string
#  check_in_time         :string
#  check_out_date        :string
#  guest_name            :string
#  guest_kana            :string
#  pms_id                :string
#  insight_memo          :text
#  nights                :integer
#  order_memo            :text
#  payment               :string
#  prop_id               :string
#  room_list             :json
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  status                :string
#  guest_phone_number    :string
#  tags                  :json
#
# Indexes
#
#  index_pms_reservations_on_line_friend_id  (line_friend_id)
#  index_pms_reservations_on_pms_id          (pms_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_friend_id => line_friends.id)
#
FactoryBot.define do
  factory :pms_reservation do
    agency_booking_number { 'MyString' }
    agency_code { 'MyString' }
    agency_name { 'MyString' }
    agency_plan_code { 'MyString' }
    agency_plan_name { 'MyString' }
    booking_date { 'MyString' }
    booking_time { 'MyString' }
    charge_claimed { 1 }
    charge_total { 1 }
    charge_type { 'MyString' }
    check_in_date { 'MyString' }
    check_in_time { 'MyString' }
    check_out_date { 'MyString' }
    guest_name { 'MyString' }
    guest_kana { 'MyString' }
    pms_id { 'MyString' }
    insight_memo { 'MyText' }
    nights { 1 }
    order_memo { 'MyText' }
    payment { 'MyString' }
    prop_id { 'MyString' }
    room_list { '' }
  end
end
