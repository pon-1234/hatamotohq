# frozen_string_literal: true

class CreateReviewQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :review_questions do |t|
      t.string :type
      t.string :title
      t.text :description
      t.json :config
      t.integer :sort_order
      t.boolean :required, default: true
      t.timestamps
    end
  end
end
