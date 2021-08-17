# frozen_string_literal: true

class CreateAutoResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :auto_responses do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :title
      t.string :status
      t.string :keyword
      t.string :keyword_status
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
