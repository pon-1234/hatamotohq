class UpdateChannelTable < ActiveRecord::Migration[6.0]
  def up
    remove_column :channels, :status
    add_column :channels, :locked, :boolean, after: :last_seen_at
  end

  def down
    add_column :channels, :status, :string
    remove_column :channels, :locked, :boolean
  end
end
