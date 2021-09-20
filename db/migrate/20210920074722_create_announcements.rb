# frozen_string_literal: true

class CreateAnnouncements < ActiveRecord::Migration[6.0]
  def change
    create_table :announcements do |t|
      t.text :title
      t.longtext :body
      t.datetime :announced_at
      t.string :status
      t.timestamps
    end
  end
end
