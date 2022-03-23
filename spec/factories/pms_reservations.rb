# frozen_string_literal: true

# == Schema Information
#
# Table name: pms_reservations
#
#  id                    :bigint           not null, primary key
#  line_friend_id        :bigint           not null
#  agency_booking_number :string(255)
#  agency_code           :string(255)
#  agency_name           :string(255)
#  agency_plan_code      :string(255)
#  agency_plan_name      :string(255)
#  booking_date          :string(255)
#  booking_time          :string(255)
#  charge_claimed        :integer
#  charge_total          :integer
#  charge_type           :string(255)
#  check_in_date         :string(255)
#  check_in_time         :string(255)
#  check_out_date        :string(255)
#  guest_name            :string(255)
#  guest_kana            :string(255)
#  pms_id                :string(255)
#  insight_memo          :text(65535)
#  nights                :integer
#  order_memo            :text(65535)
#  payment               :string(255)
#  prop_id               :string(255)
#  room_list             :json
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
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
