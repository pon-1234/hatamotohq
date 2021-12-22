# frozen_string_literal: true

# == Schema Information
#
# Table name: flex_templates
#
#  id         :bigint           not null, primary key
#  type       :string(255)
#  content    :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :flex_template do
  end
end
