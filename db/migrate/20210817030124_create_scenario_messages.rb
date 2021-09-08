# frozen_string_literal: true

class CreateScenarioMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :scenario_messages do |t|
      t.references :scenario, foreign_key: true
      t.string :status, default: 'disabled'
      t.string :name
      t.json :content
      t.integer :message_type_id
      t.integer :date
      t.string :time
      t.boolean :is_initial, default: true
      t.integer :step
      t.integer :order
      t.boolean :pause
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
