# frozen_string_literal: true

class CreateSites < ActiveRecord::Migration[6.0]
  def change
    create_table :sites do |t|
      t.text :url
      t.string :name
      t.references :folder, null: false, foreign_key: true
      t.integer :sending_count
      t.string :click_count_integer
      t.integer :receiver_count
      t.integer :visitor_count
      t.string :code

      t.timestamps
    end
    add_index :sites, :code
  end
end
