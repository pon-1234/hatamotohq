# frozen_string_literal: true

# == Schema Information
#
# Table name: reservation_precheckins
#
#  id              :bigint           not null, primary key
#  line_account_id :bigint
#  line_friend_id  :bigint
#  name            :string
#  phone_number    :string
#  check_in_date   :date
#  address         :string
#  birthday        :string
#  companion       :string
#  gender          :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_reservation_precheckins_on_line_account_id  (line_account_id)
#  index_reservation_precheckins_on_line_friend_id   (line_friend_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (line_friend_id => line_friends.id)
#
FactoryBot.define do
  factory :reservation_precheckin do
    name { 'MyString' }
    phone_number { 'MyString' }
    check_in_date { '2023-03-09' }
    address { 'MyString' }
    age_group { 'MyString' }
    companion { 'MyString' }
    gender { 1 }
  end
end
