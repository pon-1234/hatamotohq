# frozen_string_literal: true

# == Schema Information
#
# Table name: review_questions
#
#  id          :bigint           not null, primary key
#  type        :string
#  title       :string
#  description :text
#  config      :json
#  sort_order  :integer
#  required    :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :review_question do
  end
end
