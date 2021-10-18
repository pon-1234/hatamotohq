# frozen_string_literal: true

# == Schema Information
#
# Table name: survey_answers
#
#  id                 :bigint           not null, primary key
#  line_account_id    :bigint
#  line_friend_id     :bigint
#  survey_id          :bigint
#  survey_question_id :bigint
#  answer             :json
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_survey_answers_on_line_account_id     (line_account_id)
#  index_survey_answers_on_line_friend_id      (line_friend_id)
#  index_survey_answers_on_survey_id           (survey_id)
#  index_survey_answers_on_survey_question_id  (survey_question_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (line_friend_id => line_friends.id)
#  fk_rails_...  (survey_id => surveys.id)
#  fk_rails_...  (survey_question_id => survey_questions.id)
#
class SurveyAnswer < ApplicationRecord
end
