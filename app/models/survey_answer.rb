# frozen_string_literal: true

# == Schema Information
#
# Table name: survey_answers
#
#  id                 :bigint           not null, primary key
#  survey_response_id :bigint
#  survey_question_id :bigint
#  answer             :json
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_survey_answers_on_survey_question_id  (survey_question_id)
#  index_survey_answers_on_survey_response_id  (survey_response_id)
#
# Foreign Keys
#
#  fk_rails_...  (survey_question_id => survey_questions.id)
#  fk_rails_...  (survey_response_id => survey_responses.id)
#
class SurveyAnswer < ApplicationRecord
  belongs_to :survey_response
  belongs_to :survey_question
end
