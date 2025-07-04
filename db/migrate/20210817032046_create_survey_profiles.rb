# frozen_string_literal: true

class CreateSurveyProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_profiles do |t|
      t.references :line_account, foreign_key: true
      t.text :content
      t.timestamps
    end
  end
end
