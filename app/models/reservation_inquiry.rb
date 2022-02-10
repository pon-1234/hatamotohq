# frozen_string_literal: true

# == Schema Information
#
# Table name: reservation_inquiries
#
#  id         :bigint           not null, primary key
#  capacity   :integer
#  start_date :date
#  end_date   :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ReservationInquiry < ApplicationRecord
end
