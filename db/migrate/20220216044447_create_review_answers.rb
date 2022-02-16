# frozen_string_literal: true

class CreateReviewAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :review_answers do |t|
      t.references :review, foreign_key: true
      t.references :review_question, foreign_key: true
      t.text :answer
      t.timestamps
    end
  end
end
