# frozen_string_literal: true

class AddScenarioLogIdToScenarioEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :scenario_events, :scenario_log_id, :integer
    add_index :scenario_events, :scenario_log_id
  end
end
