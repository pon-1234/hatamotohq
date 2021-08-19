# frozen_string_literal: true

# == Schema Information
#
# Table name: line_friends
#
#  id              :bigint           not null, primary key
#  area            :string(255)
#  birthday        :date
#  deleted_at      :datetime
#  gender          :string(255)
#  prefecture      :string(255)
#  status          :string(255)
#  status_from_bot :string(255)      default("active")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
#
# Indexes
#
#  index_line_friends_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class LineFriend < ApplicationRecord
end
