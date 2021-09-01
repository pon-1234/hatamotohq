# frozen_string_literal: true

class CreateAutoResponseKeywords < ActiveRecord::Migration[6.0]
  def change
    create_table :auto_response_keywords do |t|
      t.references :auto_response, foreign_key: true
      t.string :keyword
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
