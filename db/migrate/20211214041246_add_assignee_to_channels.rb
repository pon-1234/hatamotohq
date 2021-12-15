# frozen_string_literal: true

class AddAssigneeToChannels < ActiveRecord::Migration[6.0]
  def change
    add_reference :channels, :assignee, foreign_key: { to_table: :users }, after: :line_friend_id
  end
end
