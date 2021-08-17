# frozen_string_literal: true

class CreateChannelParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :channel_participants do |t|
      t.references :channel, foreign_key: true
      t.references :line_customer, foreign_key: true
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
