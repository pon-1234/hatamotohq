# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :channel, foreign_key: true
      t.references :sender, polymorphic: true
      t.string :type
      t.boolean :is_bot_sender, default: 0
      t.string :line_message_id
      t.json :line_content
      t.string :line_timestamp
      t.string :line_reply_token
      t.text :slug
      t.timestamps
    end
  end
end
