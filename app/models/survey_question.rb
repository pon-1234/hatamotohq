# frozen_string_literal: true

# == Schema Information
#
# Table name: survey_questions
#
#  id         :bigint           not null, primary key
#  survey_id  :bigint
#  name       :string(255)
#  order      :integer          default(0)
#  required   :boolean          default(FALSE)
#  type       :string(255)
#  content    :json
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
  include QuestionType
  belongs_to :survey

  # validates :name, presence: true, length: { maximum: 255 }
  validates :content, presence: true
end
