# == Schema Information
#
# Table name: reservation_precheckins
#
#  id            :bigint           not null, primary key
#  name          :string(255)
#  phone_number  :string(255)
#  check_in_date :date
#  address       :string(255)
#  birthday      :string(255)
#  companion     :string(255)
#  gender        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe ReservationPrecheckin, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
