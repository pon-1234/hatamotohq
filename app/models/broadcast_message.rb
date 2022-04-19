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
  has_many :site_measurements, as: :measurable

  # Validation
  validates :content, presence: true

  accepts_nested_attributes_for :site_measurements

  def clone_to!(broadcast_id)
    new_message = self.dup
    new_message.broadcast_id = broadcast_id
    new_message.site_measurements = self.site_measurements.map(&:dup)
    new_message.save!
    new_message
  end
end
