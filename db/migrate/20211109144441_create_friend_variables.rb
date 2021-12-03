# frozen_string_literal: true

class CreateFriendVariables < ActiveRecord::Migration[6.0]
  def change
    create_table :friend_variables do |t|
      t.references :line_friend, foreign_key: true
      t.references :variable, foreign_key: true
      t.references :survey_answer, foreign_key: true
      t.text :value
      t.timestamps
    end
  end
end
