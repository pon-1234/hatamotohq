# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.references :channel, foreign_key: true
      t.references :line_customer, foreign_key: true
      t.boolean :is_bot_sender, default: 0
      t.string :attr, default: 'chat-reserve'
      t.string :line_message_id
      t.longtext :line_content
      t.string :line_timestamp
      t.string :line_reply_token
      t.text :slug
      t.timestamps
    end
  end
end
