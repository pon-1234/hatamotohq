# frozen_string_literal: true

class SyncLineFriendJob < ApplicationJob
  queue_as :default

  def perform(line_account, friend_id)
    data = LineApi::GetProfile.new(line_account.line_channel_id, line_account.line_channel_secret, friend_id).perform

    # Create or update friend info
    line_friend = LineFriend.find_or_initialize_by(line_account: line_account, line_user_id: data['line_user_id'])
    line_friend.line_picture_url = data['line_picture_url']
    line_friend.line_name = data['line_name']
    line_friend.display_name = line_friend.display_name || line_friend.line_name
    line_friend.save!

    # Create or update chat channel
    channel = Channel.find_or_initialize_by(line_account: line_account, line_friend: line_friend)
    channel.title = line_friend.display_name
    channel.avatar = line_friend.line_picture_url
    channel.save!

    # Create or update channel participant
    participant = ChannelParticipant.find_or_initialize_by(line_friend: line_friend, channel: channel)
    participant.save!
  end
end
