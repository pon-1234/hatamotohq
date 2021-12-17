# frozen_string_literal: true

# == Schema Information
#
# Table name: channels
#
#  id               :bigint           not null, primary key
#  line_account_id  :bigint
#  line_friend_id   :bigint
#  assignee_id      :bigint
#  title            :string(255)
#  avatar           :string(255)
#  last_message     :string(255)
#  last_activity_at :datetime
#  last_seen_at     :datetime
#  locked           :boolean
#  alias            :string(255)
#  slug             :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#
# Indexes
#
#  index_channels_on_assignee_id      (assignee_id)
#  index_channels_on_line_account_id  (line_account_id)
#  index_channels_on_line_friend_id   (line_friend_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_id => users.id)
#  fk_rails_...  (line_account_id => line_accounts.id)
#  fk_rails_...  (line_friend_id => line_friends.id)
#
class Channel < ApplicationRecord
  default_scope { order(last_activity_at: :desc) }
  belongs_to :line_account
  belongs_to :line_friend
  belongs_to :assignee, class_name: 'User', optional: true
  has_many :messages, dependent: :destroy, autosave: true
  has_many :remindings
  has_many :reminders, through: :remindings

  before_create do
    self.last_activity_at = Time.zone.now
    self.last_seen_at = Time.zone.now
  end

  after_create do
    # Make friend to be a participant
    ChannelMember.create(channel: self, participant: line_friend)
    # Make owner of official account to be a participant
    ChannelMember.create(channel: self, participant: line_account.owner)
  end

  def push_event_data
    {
      id: id,
      locked: locked,
      last_message: last_message,
      last_activity_at: last_activity_at,
      last_seen_at: last_seen_at,
      unread_count: unread_messages.count,
      assignee_id: assignee_id,
      line_friend: line_friend.push_event_data
    }
  end

  def lock!
    update!(locked: true)
  end

  def unlock!
    update!(locked: false)
  end

  def update_assignee(agent = nil)
    update!(assignee: agent)
  end

  def unread_messages
    messages.unread_since(last_seen_at)
  end

  # Delete all applied scenarios
  def cancel_scenarios
    ScenarioEvent.queued.where(channel_id: id).destroy_all
  end
end
