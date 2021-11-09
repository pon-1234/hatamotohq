# frozen_string_literal: true

# == Schema Information
#
# Table name: friend_variables
#
#  id               :bigint           not null, primary key
#  line_friend_id   :bigint
#  variable_id      :bigint
#  survey_answer_id :bigint
#  value            :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_friend_variables_on_line_friend_id    (line_friend_id)
#  index_friend_variables_on_survey_answer_id  (survey_answer_id)
#  index_friend_variables_on_variable_id       (variable_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_friend_id => line_friends.id)
#  fk_rails_...  (survey_answer_id => survey_answers.id)
#  fk_rails_...  (variable_id => variables.id)
#
require 'rails_helper'

RSpec.describe FriendVariable, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
