# frozen_string_literal: true

# == Schema Information
#
# Table name: scorings
#
#  id                 :bigint           not null, primary key
#  friend_variable_id :bigint
#  operation          :string(255)      default("set")
#  value              :string(255)
#  old_value          :string(255)
#  new_value          :string(255)
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
FactoryBot.define do
  factory :scoring do
  end
end
