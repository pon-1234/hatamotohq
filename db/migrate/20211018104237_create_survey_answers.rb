# frozen_string_literal: true

class CreateSurveyAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_answers do |t|
      t.references :line_account, foreign_key: true
      t.references :line_friend, foreign_key: true
      t.references :survey, foreign_key: true
      t.references :survey_question, foreign_key: true
      t.json :answer
      t.timestamps
    end
  end
end
