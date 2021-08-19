# frozen_string_literal: true

class CreateChannels < ActiveRecord::Migration[6.0]
  def change
    create_table :channels do |t|
      t.references :line_account, foreign_key: true
      t.references :line_friend, foreign_key: true
      t.string :title
      t.string :avatar
      t.text :last_message
      t.string :status, default: '1'
      t.string :alias
      t.datetime :last_message_at
      t.string :slug
      t.boolean :un_read, default: true
      t.boolean :is_mute, default: false
      t.boolean :is_pair_chat, default: true
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
