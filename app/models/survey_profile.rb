# frozen_string_literal: true

# == Schema Information
#
# Table name: survey_profiles
#
#  id                         :bigint           not null, primary key
#  content                    :text(4294967295)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  line_account_id            :bigint
#  survey_profile_template_id :bigint
#
# Indexes
#
#  index_survey_profiles_on_line_account_id             (line_account_id)
#  index_survey_profiles_on_survey_profile_template_id  (survey_profile_template_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (survey_profile_template_id => survey_profile_templates.id)
#
class SurveyProfile < ApplicationRecord
end
