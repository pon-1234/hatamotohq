require 'digest'

module WebhooksHelper
  def handle_event(event, key)
    type = event[:type]
    case type
      when 'follow'
        handle_follow(event, key)
      when 'unfollow'
        handle_unfollow(event, key)
    end
  end

  private
    def handle_follow(event, key)
      line_account = LineAccount.find_by(webhook_url: key)
      return false if line_account.nil?
      # Get user profile
      friend_id = event[:source][:userId]
      user_profile = LineApi::GetProfile.new(line_account.line_channel_id, line_account.line_channel_secret, friend_id).perform
      # Return if could not file user profile
      return false if user_profile.nil?
      # Update or create line friend
      line_friend = LineFriend.find_or_initialize_by(line_account: line_account, line_user_id: friend_id)
      line_friend.line_picture_url = user_profile['pictureUrl']
      line_friend.line_name = user_profile['displayName']
      line_friend.display_name = line_friend.display_name || line_friend.line_name
      line_friend.save
      # Create or reopen channel
      channel_alias = Digest::MD5.hexdigest("#{key}_#{friend_id}")
      channel = Channel.find_or_initialize_by(line_account: line_account, line_friend: line_friend)
      channel.status = :active
      channel.avatar = line_friend.line_picture_url
      channel.title = line_friend.line_name
      channel.last_timestamp = event['timestamp'] / 1000
      channel.alias = channel_alias
      channel.un_read = 0
      channel.save
      # Redis::publish('redis_lineFollow', json_encode([
      #     'channel' => $channel,
      #     'src' => $customer,
      #     'dest' => $lineSetting->lineAccount
      # ]));
    end

    def handle_unfollow(event, key)
      line_account = LineAccount.find_by(webhook_url: key)
      return false if line_account.nil?
      # Get user profile
      friend_id = event[:source][:userId]
      # Check if friend alredy in db
      line_friend = LineFriend.find_by(line_account: line_account, line_user_id: friend_id)
      return false if line_friend.nil?
      # Change friend status to block if existing in db
      line_friend.status = :block
      line_friend.save
      # Change channel status to block
      channel = Channel.find_by(line_account: line_account, line_friend: line_friend)
      return false if channel.nil?
      channel.status = :block
      channel.save
      # Redis::publish('redis_lineFollow', json_encode([
      #     'channel' => $channel,
      #     'src' => $customer,
      #     'dest' => $lineSetting->lineAccount
      # ]));
    end
end
