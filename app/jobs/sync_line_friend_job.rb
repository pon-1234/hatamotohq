# frozen_string_literal: true

class SyncLineFriendJob < ApplicationJob
  queue_as :default

  def perform(line_account, friend_id)
    data = LineApi::GetProfile.new(line_account).perform(friend_id)

    # Create or update friend info
    line_friend = LineFriend.find_or_initialize_by(line_account: line_account, line_user_id: data['userId'])
    line_friend.line_picture_url = data['pictureUrl']
    line_friend.line_name = data['displayName']
    line_friend.display_name = line_friend.display_name || line_friend.line_name
    line_friend.save!

    # Create or update chat channel
    channel = Channel.find_or_initialize_by(line_account: line_account, line_friend: line_friend)
    channel.title = line_friend.display_name
    channel.avatar = line_friend.line_picture_url
    channel.save!

    # Create or update channel participant
    participant = ChannelMember.find_or_initialize_by(line_friend: line_friend, channel: channel)
    participant.save!
  end
end
