# frozen_string_literal: true

class CreateTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :templates do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :name
      t.string :type
      t.timestamps
    end
  end
end
