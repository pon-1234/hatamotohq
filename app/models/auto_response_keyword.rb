# frozen_string_literal: true

# == Schema Information
#
# Table name: auto_response_keywords
#
#  id               :bigint           not null, primary key
#  auto_response_id :bigint
#  keyword          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#
# Indexes
#
#  index_auto_response_keywords_on_auto_response_id  (auto_response_id)
#
# Foreign Keys
#
#  fk_rails_...  (auto_response_id => auto_responses.id)
#
class AutoResponseKeyword < ApplicationRecord
  # TODO using elasticsearch here
  belongs_to :auto_response

  # Validation
  validates :keyword, presence: true, length: { maximum: 255 }

  before_save do
    self.keyword = self.keyword.downcase
  end

  def clone_to!(auto_response_id)
    new_keyword = self.dup
    new_keyword.auto_response_id = auto_response_id
    new_keyword.save!
    new_keyword
  end
end
