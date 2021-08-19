# frozen_string_literal: true

# == Schema Information
#
# Table name: survey_questions
#
#  id          :bigint           not null, primary key
#  content     :text(4294967295)
#  index       :integer          default(0)
#  is_required :boolean          default(FALSE)
#  name        :string(255)
#  type        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  survey_id   :bigint
#
# Indexes
#
#  index_survey_questions_on_survey_id  (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (survey_id => surveys.id)
#
class SurveyQuestion < ApplicationRecord
end
