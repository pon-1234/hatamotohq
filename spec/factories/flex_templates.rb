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
FactoryBot.define do
  factory :flex_template do
  end
end
