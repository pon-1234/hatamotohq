# frozen_string_literal: true

class DestroyModelUnreadMessage < ActiveRecord::Migration[6.0]
  def up
    drop_table :unread_messages
  end

  def down
    create_table :unread_messages do |t|
      t.references :line_account, foreign_key: true
      t.references :channel, foreign_key: true
      t.references :last_message, foreign_key: { to_table: :messages }
      t.integer :total
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
