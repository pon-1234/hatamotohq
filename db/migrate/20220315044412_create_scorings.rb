# frozen_string_literal: true

class CreateScorings < ActiveRecord::Migration[6.0]
  def change
    create_table :scorings do |t|
      t.references :friend_variable, foreign_key: true
      t.string :operation, default: 'set'
      t.string :value
      t.string :old_value
      t.string :new_value
      t.timestamps
    end
  end
end
