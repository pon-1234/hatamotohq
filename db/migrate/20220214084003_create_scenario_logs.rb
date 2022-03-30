# frozen_string_literal: true

class CreateScenarioLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :scenario_logs do |t|
      t.references :scenario, null: false, foreign_key: true
      t.references :line_friend, null: false, foreign_key: true
      t.string :status
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
