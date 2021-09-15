# frozen_string_literal: true

class AddTypeToScenarioEventsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :scenario_events, :type, :string, after: :scenario_message_id
    add_column :scenario_events, :content, :json, after: :type
  end
end
