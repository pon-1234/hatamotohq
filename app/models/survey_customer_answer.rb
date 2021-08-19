# frozen_string_literal: true

# == Schema Information
#
# Table name: survey_customer_answers
#
#  id                 :bigint           not null, primary key
#  content            :text(4294967295)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  line_account_id    :bigint
#  survey_customer_id :bigint
#  survey_id          :bigint
#  survey_question_id :bigint
#
# Indexes
#
#  index_survey_customer_answers_on_line_account_id     (line_account_id)
#  index_survey_customer_answers_on_survey_customer_id  (survey_customer_id)
#  index_survey_customer_answers_on_survey_id           (survey_id)
#  index_survey_customer_answers_on_survey_question_id  (survey_question_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (survey_customer_id => survey_customers.id)
#  fk_rails_...  (survey_id => surveys.id)
#  fk_rails_...  (survey_question_id => survey_questions.id)
#
class SurveyCustomerAnswer < ApplicationRecord
end
