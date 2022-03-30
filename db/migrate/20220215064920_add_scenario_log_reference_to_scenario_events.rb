# frozen_string_literal: true

class AddScenarioLogReferenceToScenarioEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference :scenario_events, :scenario_log, foreign_key: true, null: true
  end
end
