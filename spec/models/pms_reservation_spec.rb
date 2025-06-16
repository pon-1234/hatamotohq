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
require 'rails_helper'

RSpec.describe PmsReservation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
