# frozen_string_literal: true

class CreateScenarioEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :scenario_events do |t|
      t.references :line_account, foreign_key: true
      t.references :scenario, foreign_key: true
      t.references :scenario_message, foreign_key: true
      t.references :channel, foreign_key: true
      t.datetime :schedule_at
      t.integer :order
      t.string :status
      t.timestamps
    end
  end
end
