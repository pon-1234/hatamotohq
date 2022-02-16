# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.references :client, foreign_key: true
      t.references :line_friend, foreign_key: true
      t.timestamps
    end
  end
end
