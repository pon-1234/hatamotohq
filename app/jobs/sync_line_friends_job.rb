# frozen_string_literal: true

class SyncLineFriendsJob < ApplicationJob
  queue_as :default

  def perform(line_account_id)
    line_account = LineAccount.find(line_account_id)
    # Fetch friend list
    friend_ids = LineApi::GetFollowerIds.new(line_account.line_channel_id, line_account.line_channel_secret).perform
    return if friend_ids.blank?
    friend_ids.each do |friend_id|
      SyncLineFriendJob.perform_later(line_account, friend_id)
    end
  end
end
