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
FactoryBot.define do
  factory :site_reference do
    code { 'MyString' }
    line_user_id { 'MyString' }
    site_measurement_id { 'MyString' }
  end
end
