# frozen_string_literal: true

class CreateSurveyCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_customers do |t|
      t.references :survey, foreign_key: true
      t.references :line_customer, foreign_key: true
      t.integer :answer_num, default: 0
      t.timestamps
    end
  end
end
