# frozen_string_literal: true

class CreateLineFriends < ActiveRecord::Migration[6.0]
  def change
    create_table :line_friends do |t|
      t.references :line_account, foreign_key: true
      t.string :line_picture_url
      t.string :line_user_id
      t.string :line_name
      t.string :display_name
      t.string :status, default: 'active'
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
