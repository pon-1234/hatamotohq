# frozen_string_literal: true

# == Schema Information
#
# Table name: auto_response_keywords
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  keyword          :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auto_response_id :bigint
#  line_account_id  :bigint
#
# Indexes
#
#  index_auto_response_keywords_on_auto_response_id  (auto_response_id)
#  index_auto_response_keywords_on_line_account_id   (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class AutoResponseKeyword < ApplicationRecord
  # TODO using elasticsearch here
  belongs_to :auto_response

  # Validation
  validates :keyword, presence: true, length: { maximum: 255 }
end
