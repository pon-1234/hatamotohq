class AddIsLastToScenarioEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :scenario_events, :is_last, :boolean, after: :status, default: false
  end
end
