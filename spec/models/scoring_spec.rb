# frozen_string_literal: true

# == Schema Information
#
# Table name: scorings
#
#  id                 :bigint           not null, primary key
#  friend_variable_id :bigint
#  operation          :string           default("set")
#  value              :string
#  old_value          :string
#  new_value          :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_scorings_on_friend_variable_id  (friend_variable_id)
#
# Foreign Keys
#
#  fk_rails_...  (friend_variable_id => friend_variables.id)
#
require 'rails_helper'

RSpec.describe Scoring, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
