class AddLastSeenAtToChannel < ActiveRecord::Migration[6.0]
  def up
    add_column :channels, :last_seen_at, :datetime, after: :last_activity_at
  end

  def down
    remove_column :channels, :last_seen_at
  end
end
