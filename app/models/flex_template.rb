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

  def self.rsv_available_template
    # In future, multiple template can be applied for clients
    @rsv_available_template = FlexTemplate.rsv_available.first
  end

  def self.rsv_unavailable_template
    # In future, multiple template can be applied for clients
    @rsv_unavailable_template = FlexTemplate.rsv_unavailable.first
  end
end
