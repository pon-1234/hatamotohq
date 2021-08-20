# frozen_string_literal: true

# == Schema Information
#
# Table name: channel_participants
#
#  id               :bigint           not null, primary key
#  deleted_at       :datetime
#  participant_type :string(255)
#  unread_count     :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  channel_id       :bigint
#  participant_id   :bigint
#
# Indexes
#
#  index_channel_participants_on_channel_id               (channel_id)
#  index_participant_id_and_type_on_channel_participants  (participant_type,participant_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#
class ChannelParticipant < ApplicationRecord
  belongs_to :channel
  belongs_to :participant, polymorphic: true
end
