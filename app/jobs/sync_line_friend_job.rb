class SyncLineFriendJob < ApplicationJob
  queue_as :default

  def perform(line_account, friend_id)
    data = LineApi::GetProfile.new(line_account.line_channel_id, line_account.line_channel_secret, friend_id).perform
    lf_data = {
      line_picture_url: data['line_picture_url'],
      line_user_id: data['line_user_id'],
      line_name: data['line_name']
    }
    line_friend = LineFriend.find_or_initialize_by(line_account: line_account, line_user_id: data['line_user_id'])
    line_friend.line_picture_url = data['line_picture_url']
    line_friend.line_name = data['line_name']
    line_friend.display_name = line_friend.display_name || line_friend.line_name
    line_friend.save
  end
end
