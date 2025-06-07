# frozen_string_literal: true

class CreateSurveyCustomerAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_customer_answers do |t|
      t.references :line_account, foreign_key: true
      t.references :survey, foreign_key: true
      t.references :survey_question, foreign_key: true
      t.references :survey_customer, foreign_key: true
      t.text :content
      t.timestamps
    end
  end
end
