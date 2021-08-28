# frozen_string_literal: true

require 'digest'

module WebhooksHelper
  def handle_event(event, key)
    line_account = LineAccount.find_by(webhook_url: key)
    return false if line_account.nil?

    type = event[:type]
    case type
    when 'follow'
      handle_follow(event, line_account)
    when 'unfollow'
      handle_unfollow(event, line_account)
    when 'message'
      handle_message(event, line_account)
    end
  end

  private
    def handle_follow(event, line_account)
      friend_id = event[:source][:userId]
      line_friend = add_friend(line_account, friend_id)
   
      # Redis::publish('redis_lineFollow', json_encode([
      #     'channel' => $channel,
      #     'src' => $customer,
      #     'dest' => $lineSetting->lineAccount
      # ]));

      return line_friend.present?
    end

    def handle_unfollow(event, line_account)
      friend_id = event[:source][:userId]
      # Check if friend alredy in db
      line_friend = LineFriend.where(line_account: line_account, line_user_id: friend_id).first
      return false if line_friend.nil?
      # Change friend status to block if existing in db
      line_friend.status = 'block'
      line_friend.save
      # Change channel status to block
      channel = Channel.where(line_account: line_account, line_friend: line_friend).first
      return false if channel.nil?
      channel.status = 'block'
      channel.save
      # Redis::publish('redis_lineFollow', json_encode([
      #     'channel' => $channel,
      #     'src' => $customer,
      #     'dest' => $lineSetting->lineAccount
      # ]));
      true
    end

    def handle_message(event, line_account)
      p '----handle message-----', event.to_json
      # Get user profile
      friend_id = event[:source][:userId]
      line_friend = LineFriend.where(line_account: line_account, line_user_id: friend_id).first
      # Store friend data if does not exists
      unless line_friend
        line_friend = add_friend(line_account, friend_id)
        return false if line_friend.nil?        
      end
      # Bot could not send to itself
      return false if line_friend.line_user_id == line_account.line_user_id
      # Increase unread message count by 1
      channel = line_friend.channel
    end

    def add_friend(line_account, friend_id)
      user_profile = LineApi::GetProfile.new(line_account.line_channel_id, line_account.line_channel_secret, friend_id).perform
      # Return if could not file user profile
      return nil if user_profile.nil?
      line_friend = LineFriend.find_or_initialize_by(line_account: line_account, line_user_id: friend_id)
      line_friend.line_picture_url = user_profile['pictureUrl']
      line_friend.line_name = user_profile['displayName']
      line_friend.display_name = line_friend.display_name || line_friend.line_name
      line_friend.save

      # Create or reopen channel
      channel = Channel.find_or_initialize_by(line_account: line_account, line_friend: line_friend)
      channel_alias = Digest::MD5.hexdigest("#{line_account.webhook_url}_#{friend_id}")
      channel.status = 'active'
      channel.avatar = line_friend.line_picture_url
      channel.title = line_friend.line_name
      channel.last_timestamp = event['timestamp'] / 1000
      channel.alias = channel_alias
      channel.un_read = 0
      channel.save

      line_friend
    end
end
