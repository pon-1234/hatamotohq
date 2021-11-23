# frozen_string_literal: true

class CreateInsights < ActiveRecord::Migration[6.0]
  def change
    create_table :insights do |t|
      t.references :line_account, foreign_key: true
      t.string :type, default: 'daily'
      t.date :date
      t.integer :broadcast
      t.integer :targeting
      t.integer :auto_response
      t.integer :welcome_response
      t.integer :chat
      t.integer :api_broadcast
      t.integer :api_push
      t.integer :api_multicast
      t.integer :api_narrowcast
      t.integer :api_reply
      t.timestamps
    end
  end
end
