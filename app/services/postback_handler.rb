# frozen_string_literal: true

class PostbackHandler
  def initialize(line_account, event, action)
    @line_account = line_account
    @event = event
    @action = action
    friend_id = @event[:source][:userId]
    @friend = LineFriend.find_by(line_account: @line_account, line_user_id: friend_id)
    @reply_token = @event['replyToken']
    ActionHandlerJob.perform_now(@friend, @action, @reply_token)
  end
end
