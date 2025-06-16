# frozen_string_literal: true

# == Schema Information
#
# Table name: reservations
#
#  id              :bigint           not null, primary key
#  line_friend_id  :bigint
#  room_id         :string
#  status          :string           default("wait")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifier_id     :string
#  line_account_id :bigint
#  room_name       :string
#  stock           :integer
#  stock_from      :datetime
#  stock_to        :datetime
#
# Indexes
#
#  index_reservations_on_line_account_id  (line_account_id)
#  index_reservations_on_line_friend_id   (line_friend_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (line_friend_id => line_friends.id)
#
FactoryBot.define do
  factory :reservation do
  end
end
