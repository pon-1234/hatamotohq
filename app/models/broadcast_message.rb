# frozen_string_literal: true

# == Schema Information
#
# Table name: broadcast_messages
#
#  id              :bigint           not null, primary key
#  content         :json
#  deleted_at      :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  broadcast_id    :bigint
#  message_type_id :integer
#
# Indexes
#
#  index_broadcast_messages_on_broadcast_id  (broadcast_id)
#
# Foreign Keys
#
#  fk_rails_...  (broadcast_id => broadcasts.id)
#
class BroadcastMessage < ApplicationRecord
  belongs_to :broadcast

  # Validation
  validates :content, presence: true
end
