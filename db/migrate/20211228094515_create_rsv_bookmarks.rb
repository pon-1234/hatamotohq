# frozen_string_literal: true

class CreateRsvBookmarks < ActiveRecord::Migration[6.0]
  def change
    create_table :rsv_bookmarks do |t|
      t.references :line_friend, foreign_key: true
      t.string :room_id
      t.string :status, default: 'wait'
      t.timestamps
    end
  end
end
