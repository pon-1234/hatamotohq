# frozen_string_literal: true

class RemoveUnusedTables < ActiveRecord::Migration[6.0]
  def up
    drop_table :survey_customer_answers
    drop_table :survey_customers
  end

  def down
    create_table :survey_customers do |t|
      t.references :survey, foreign_key: true
      t.references :line_account, foreign_key: true
      t.integer :answer_num, default: 0
      t.timestamps
    end

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
