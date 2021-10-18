# frozen_string_literal: true

class CreateSurveyFriends < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_friends do |t|
      t.references :survey, foreign_key: true
      t.references :line_friend, foreign_key: true
      t.integer :answer_count, default: 0
      t.timestamps
    end
  end
end
