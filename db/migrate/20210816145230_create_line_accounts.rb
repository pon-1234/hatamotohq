# frozen_string_literal: true

class CreateLineAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :line_accounts do |t|
      t.string :line_user_id
      t.string :line_picture_url
      t.string :line_name
      t.string :display_name
      t.string :line_client_id
      t.string :line_channel_access_token
      t.string :line_channel_secret
      t.string :invite_url
      t.string :webhook_url
      t.string :liff_id
      t.text :note
      t.string :status, default: 'inactive'
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
