# frozen_string_literal: true

class CreateChannelParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_participants do |t|
      t.references :channel, foreign_key: true
      t.references :participant, polymorphic: true, index: { name: 'index_participant_id_and_type_on_channel_participants' }
      t.integer :unread_count, default: 0
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
