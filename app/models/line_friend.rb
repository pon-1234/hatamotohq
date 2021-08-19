# frozen_string_literal: true

# == Schema Information
#
# Table name: line_friends
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  display_name     :string(255)
#  line_name        :string(255)
#  line_picture_url :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  line_account_id  :bigint
#  line_user_id     :string(255)
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
  belongs_to :line_account
end
