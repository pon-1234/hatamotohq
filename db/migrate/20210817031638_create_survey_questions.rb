# frozen_string_literal: true

class CreateSurveyQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_questions do |t|
      t.references :survey, foreign_key: true
      t.string :name
      t.integer :index, default: 0
      t.boolean :is_required, default: 0
      t.string :type
      t.longtext :content
      t.timestamps
    end
  end
end
