# frozen_string_literal: true

# == Schema Information
#
# Table name: site_references
#
#  id                  :bigint           not null, primary key
#  code                :string
#  line_user_id        :string
#  site_measurement_id :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_site_references_on_code  (code)
#
class SiteReference < ApplicationRecord
  belongs_to :site_measurement

  validates :code, presence: true, uniqueness: true

  def line_friend
    @line_friend ||= LineFriend.find_by line_user_id: line_user_id
  end

  def self.generate_code
    loop do
      code = SecureRandom.alphanumeric(6)
      break code unless SiteReference.exists?(code: code)
    end
  end
end
