# frozen_string_literal: true

class CreateAutoResponseKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :auto_response_keywords do |t|
      t.references :line_account, foreign_key: true
      t.references :auto_response
      t.string :keyword
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
