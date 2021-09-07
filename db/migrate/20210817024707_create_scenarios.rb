# frozen_string_literal: true

class CreateScenarios < ActiveRecord::Migration[6.0]
  def change
    create_table :scenarios do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :title
      t.string :description
      t.string :status, default: 'disabled'
      t.string :mode, default: 'date'
      t.string :type, default: 'manual' # or 'auto'
      t.json :after_action
      t.integer :scenario_messages_count
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
