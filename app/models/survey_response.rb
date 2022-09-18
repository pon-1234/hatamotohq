# frozen_string_literal: true

# == Schema Information
#
# Table name: survey_responses
#
#  id             :bigint           not null, primary key
#  survey_id      :bigint
#  line_friend_id :bigint
#  answer_count   :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_survey_responses_on_line_friend_id  (line_friend_id)
#  index_survey_responses_on_survey_id       (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_friend_id => line_friends.id)
#  fk_rails_...  (survey_id => surveys.id)
#
class SurveyResponse < ApplicationRecord
  belongs_to :survey
  belongs_to :line_friend
  delegate :name, to: :line_friend, prefix: true
  has_many :survey_answers

  after_create do
    distribute_system_log
  end

  private
    def distribute_system_log
      Messages::SystemLogBuilder.new(self.line_friend.channel).perform_survey(self.survey)
    end
end
