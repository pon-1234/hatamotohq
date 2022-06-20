# frozen_string_literal: true

class CreateStreamRoutes < ActiveRecord::Migration[6.0]
  def change
    create_table :stream_routes do |t|
      t.references :folder, null: false, foreign_key: true
      t.string :name
      t.json :actions
      t.string :code
      t.boolean :run_add_friend_actions, default: false
      t.boolean :always_run_actions, default: false

      t.timestamps
    end
  end
end
