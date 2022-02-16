# frozen_string_literal: true

# == Schema Information
#
# Table name: review_answers
#
#  id                 :bigint           not null, primary key
#  review_id          :bigint
#  review_question_id :bigint
#  answer             :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_review_answers_on_review_id           (review_id)
#  index_review_answers_on_review_question_id  (review_question_id)
#
# Foreign Keys
#
#  fk_rails_...  (review_id => reviews.id)
#  fk_rails_...  (review_question_id => review_questions.id)
#
FactoryBot.define do
  factory :review_answer do
  end
end
