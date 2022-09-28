# frozen_string_literal: true

# == Schema Information
#
# Table name: reservation_inquiries
#
#  id         :bigint           not null, primary key
#  num_room   :integer
#  date_start :date
#  date_end   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ReservationInquiry < ApplicationRecord
end
