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
FactoryBot.define do
  factory :reservation_precheckin do
    name { "MyString" }
    phone_number { "MyString" }
    check_in_date { "2023-03-09" }
    address { "MyString" }
    age_group { "MyString" }
    companion { "MyString" }
    gender { 1 }
  end
end
