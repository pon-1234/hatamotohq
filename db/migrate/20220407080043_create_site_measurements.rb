# frozen_string_literal: true

class CreateSiteMeasurements < ActiveRecord::Migration[6.0]
  def change
    create_table :site_measurements do |t|
      t.integer :measurable_id
      t.string :measurable_type
      t.json :actions
      t.integer :sending_count
      t.integer :click_count
      t.integer :receiver_count
      t.integer :visitor_count
      t.references :site, null: false, foreign_key: true
      t.string :site_name
      t.text :redirect_url

      t.timestamps
    end
    add_index :site_measurements, :measurable_id
    add_index :site_measurements, :measurable_type
  end
end
