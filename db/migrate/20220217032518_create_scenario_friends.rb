# frozen_string_literal: true

class CreateScenarioFriends < ActiveRecord::Migration[6.0]
  def change
    create_table :scenario_friends do |t|
      t.references :scenario, null: false, foreign_key: true
      t.references :line_friend, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
