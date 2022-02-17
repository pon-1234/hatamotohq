# frozen_string_literal: true

class AddSendingFriendCountAndSentFriendCountToScenarios < ActiveRecord::Migration[6.0]
  def change
    add_column :scenarios, :sending_friend_count, :integer, default: 0
    add_column :scenarios, :sent_friend_count, :integer, default: 0
  end
end
