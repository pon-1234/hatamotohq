class AutoResponseJob < ApplicationJob
  queue_as :default

  def perform(event, line_account_id, line_friend_id)
    message_text = event[:message][:text]
  end
end
