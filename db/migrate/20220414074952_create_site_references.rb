# frozen_string_literal: true

class CreateSiteReferences < ActiveRecord::Migration[6.0]
  def change
    create_table :site_references do |t|
      t.string :code
      t.string :line_user_id
      t.string :site_measurement_id

      t.timestamps
    end
    add_index :site_references, :code
  end
end
