# frozen_string_literal: true

class AcquireFriendJob < ApplicationJob
  queue_as :default

  def perform(friend_id)
    friend = LineFriend.find(friend_id)
    scenarios = Scenario.where(line_account: friend.line_account).auto
    byebug
  end
end
