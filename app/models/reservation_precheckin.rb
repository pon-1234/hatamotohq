# == Schema Information
#
# Table name: reservation_precheckins
#
#  id            :bigint           not null, primary key
#  name          :string(255)
#  phone_number  :string(255)
#  check_in_date :date
#  address       :string(255)
#  age_group     :string(255)
#  companion     :string(255)
#  gender        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class ReservationPrecheckin < ApplicationRecord
end
