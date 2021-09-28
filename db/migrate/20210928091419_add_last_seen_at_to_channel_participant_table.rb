class AddLastSeenAtToChannelParticipantTable < ActiveRecord::Migration[6.0]
  def up
    rename_table :channel_participants, :channel_members
    remove_column :channel_members, :unread_count
  end

  def down
    add_column :channel_members, :unread_count, :integer
    rename_table :channel_members, :channel_participants
  end
end
