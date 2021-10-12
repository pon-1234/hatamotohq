# frozen_string_literal: true

# == Schema Information
#
# Table name: auto_response_messages
#
#  id               :bigint           not null, primary key
#  content          :json
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auto_response_id :bigint
#  message_type_id  :integer
#
# Indexes
#
#  index_auto_response_messages_on_auto_response_id  (auto_response_id)
#
# Foreign Keys
#
#  fk_rails_...  (auto_response_id => auto_responses.id)
#
class AutoResponseMessage < ApplicationRecord
  belongs_to :auto_response

  def clone_to!(auto_response_id)
    new_message = self.dup
    new_message.auto_response_id = auto_response_id
    new_message.save!
    new_message
  end
end
