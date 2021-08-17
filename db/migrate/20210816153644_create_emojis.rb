# frozen_string_literal: true

class CreateEmojis < ActiveRecord::Migration[6.0]
  def change
    create_table :emojis do |t|
      t.string :package_id
      t.string :line_emoji_id
      t.timestamps
    end
  end
end
