# frozen_string_literal: true

# == Schema Information
#
# Table name: flex_templates
#
#  id           :bigint           not null, primary key
#  type         :string
#  content      :json
#  html_content :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe FlexTemplate, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
