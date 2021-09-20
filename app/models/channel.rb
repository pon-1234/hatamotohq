# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id               :bigint           not null, primary key
#  line_account_id  :bigint
#  line_friend_id   :bigint
#  title            :string(255)
#  avatar           :string(255)
#  last_message     :string(255)
#  status           :string(255)      default(NULL)
#  last_activity_at :datetime
#  alias            :string(255)
#  slug             :string(255)
#  un_read          :boolean          default(TRUE)
#  is_mute          :boolean          default(FALSE)
#  is_pair_chat     :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#
# Indexes
#
#  index_channels_on_line_account_id  (line_account_id)
#  index_channels_on_line_friend_id   (line_friend_id)
#
# Foreign Keys
#
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (line_friend_id => line_friends.id)
#
class Channel < ApplicationRecord
  belongs_to :line_account
  belongs_to :line_friend
  has_many :messages, dependent: :destroy, autosave: true

  enum status: { active: 'active', block: 'block' }, _prefix: true

  after_create do
    # Make friend to be a participant
    ChannelParticipant.create(channel: self, participant: line_friend)
    # Make owner of official account to be a participant
    ChannelParticipant.create(channel: self, participant: line_account.owner)
  end
end
