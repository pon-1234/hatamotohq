# frozen_string_literal: true

require 'digest'

module WebhooksHelper
  def handle_event(event, key)
    @event = event
    @line_account = LineAccount.find_by(webhook_url: key)
    return false if @line_account.nil?

    @friend_id = @event[:source][:userId]
    type = @event[:type]
    case type
    when 'follow'
      handle_follow
    when 'unfollow'
      handle_unfollow
    when 'message'
      handle_message
    when 'postback'
      handle_postback
    end
  end

  private
    def handle_follow
      line_friend = add_friend(@friend_id)
      line_friend.present?
    end

    def handle_unfollow
      # Check if friend alredy in db
      line_friend = LineFriend.where(line_account: @line_account, line_user_id: @friend_id).first
      return false if line_friend.nil?
      # Change friend status to block if existing in db
      line_friend.update_columns(status: 'blocked')
      # Change channel status to block
      channel = Channel.where(line_account: @line_account, line_friend: line_friend).first
      return false if channel.nil?
      channel.update_columns(status: 'blocked')
      true
    end

    def handle_message
      # Get user profile
      line_friend = LineFriend.where(line_account: @line_account, line_user_id: @friend_id).first
      # Store friend data if does not exists
      unless line_friend
        line_friend = add_friend(@friend_id)
        return false if line_friend.nil?
      end
      # Bot could not send to itself
      return false if line_friend.line_user_id == @line_account.line_user_id
      channel = line_friend.channel
      # Create a message
      message = create_message(channel, line_friend, @event)
      # Increase unread message count by 1
      update_channel_last_message(channel)
    rescue => e
      logger.error(e)
    end

    def handle_postback
      # Get mapper key
      key = @event[:postback][:data]
      action = PostbackMapper.where(key: key)&.first&.value
      return false if action.blank?

      if action[:displayText].present?
        # TODO: send text message
      end

      PostbackHandler.new(@line_account, @event, action).perform
    end

    private
      # Store new friend data when adding new friend, or unblocking friend
      # The existing friend in LINE system may not exists in this system, so when sending
      # a message from LINE we need to check and store friend if needs
      def add_friend(friend_id)
        user_profile = LineApi::GetProfile.new(@line_account.line_channel_id, @line_account.line_channel_secret, friend_id).perform
        # Return if could not file user profile
        return nil if user_profile.nil?
        line_friend = LineFriend.find_or_initialize_by(line_account: @line_account, line_user_id: friend_id)
        line_friend.line_picture_url = user_profile['pictureUrl']
        line_friend.line_name = user_profile['displayName']
        line_friend.display_name = line_friend.display_name || line_friend.line_name
        line_friend.save

        # Create or reopen channel
        channel = Channel.find_or_initialize_by(line_account: @line_account, line_friend: line_friend)
        channel_alias = Digest::MD5.hexdigest("#{@line_account.webhook_url}_#{friend_id}")
        channel.status = 'active'
        channel.avatar = line_friend.line_picture_url
        channel.title = line_friend.line_name
        channel.alias = channel_alias
        channel.un_read = 0
        channel.save!

        line_friend
      end

      # When incoming message is reached, the number of unread messages is increased by 1
      # Last message data is also updated
      def update_channel_last_message(channel)
        channel.un_read = 1
        channel.last_message = @event[:message].to_json
        channel.save!
      end

      def create_message(channel, sender, body)
        mb = Messages::MessageBuilder.new(sender, channel, body)
        message = mb.perform
      end
end
