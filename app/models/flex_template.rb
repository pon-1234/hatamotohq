# frozen_string_literal: true

# == Schema Information
#
# Table name: flex_templates
#
#  id           :bigint           not null, primary key
#  type         :string(255)
#  content      :json
#  html_content :text(65535)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class FlexTemplate < ApplicationRecord
  # Scope
  enum type: { rsv_available: 'rsv_available', rsv_unavailable: 'rsv_unavailable' }

  def self.rsv_available_content
    # In future, multiple template can be applied for clients
    @rsv_available_content ||= FlexTemplate.rsv_available.first&.content
  end

  def self.rsv_unavailable_content
    # In future, multiple template can be applied for clients
    @rsv_unavailable_content ||= FlexTemplate.rsv_unavailable.first&.content
  end
end
