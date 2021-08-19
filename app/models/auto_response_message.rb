# frozen_string_literal: true

# == Schema Information
#
# Table name: auto_response_messages
#
#  id               :bigint           not null, primary key
#  content          :text(65535)
#  message_type     :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  auto_response_id :bigint
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
end
