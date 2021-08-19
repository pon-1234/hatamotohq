# frozen_string_literal: true

# == Schema Information
#
# Table name: survey_customers
#
#  id              :bigint           not null, primary key
#  answer_num      :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  line_account_id :bigint
#  survey_id       :bigint
#
# Indexes
#
#  index_survey_customers_on_line_account_id  (line_account_id)
#  index_survey_customers_on_survey_id        (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (survey_id => surveys.id)
#
class SurveyCustomer < ApplicationRecord
end
