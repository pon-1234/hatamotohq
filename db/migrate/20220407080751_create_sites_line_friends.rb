# frozen_string_literal: true

class CreateSitesLineFriends < ActiveRecord::Migration[6.0]
  def change
    create_table :sites_line_friends do |t|
      t.references :site, null: false, foreign_key: true
      t.references :line_friend, null: false, foreign_key: true

      t.timestamps
    end
  end
end
