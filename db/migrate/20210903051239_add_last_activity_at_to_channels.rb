# frozen_string_literal: true

class AddLastActivityAtToChannels < ActiveRecord::Migration[6.0]
  def up
    add_column :channels, :last_activity_at, :datetime, after: :status
    remove_column :channels, :last_timestamp
  end

  def down
    remove_column :channels, :last_activity_at
    add_column :channels, :last_timestamp, :datetime
  end
end
