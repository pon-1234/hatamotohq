# frozen_string_literal: true

# == Schema Information
#
# Table name: channel_members
#
#  id               :bigint           not null, primary key
#  channel_id       :bigint
#  participant_type :string(255)
#  participant_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#
# Indexes
#
#  index_channel_members_on_channel_id                    (channel_id)
#  index_participant_id_and_type_on_channel_participants  (participant_type,participant_id)
#
# Foreign Keys
#
#  fk_rails_...  (channel_id => channels.id)
#
class ChannelMember < ApplicationRecord
  belongs_to :channel
  belongs_to :participant, polymorphic: true
end
