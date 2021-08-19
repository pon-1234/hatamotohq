# frozen_string_literal: true

# == Schema Information
#
# Table name: survey_profile_templates
#
#  id              :bigint           not null, primary key
#  description     :string(255)
#  field_name      :string(255)
#  status          :string(255)      default("enable")
#  type            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  folder_id       :bigint
#  line_account_id :bigint
#
# Indexes
#
#  index_survey_profile_templates_on_folder_id        (folder_id)
#  index_survey_profile_templates_on_line_account_id  (line_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (folder_id => folders.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#
class SurveyProfileTemplate < ApplicationRecord
end
