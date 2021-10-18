# frozen_string_literal: true

# == Schema Information
#
# Table name: survey_friends
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
#  index_survey_friends_on_line_friend_id  (line_friend_id)
#  index_survey_friends_on_survey_id       (survey_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_friend_id => line_friends.id)
#  fk_rails_...  (survey_id => surveys.id)
#
require 'rails_helper'

RSpec.describe SurveyFriend, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
