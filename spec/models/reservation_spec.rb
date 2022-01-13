# frozen_string_literal: true

# == Schema Information
#
# Table name: reservations
#
#  id              :bigint           not null, primary key
#  line_friend_id  :bigint
#  room_id         :string(255)
#  callback_url    :string(255)
#  status          :string(255)      default("wait")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
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
require 'rails_helper'

RSpec.describe Reservation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
