# frozen_string_literal: true

# == Schema Information
#
# Table name: site_references
#
#  id                  :bigint           not null, primary key
#  code                :string(255)
#  line_user_id        :string(255)
#  site_measurement_id :string(255)
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
end
