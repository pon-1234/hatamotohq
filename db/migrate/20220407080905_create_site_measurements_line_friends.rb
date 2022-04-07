# frozen_string_literal: true

class CreateSiteMeasurementsLineFriends < ActiveRecord::Migration[6.0]
  def change
    create_table :site_measurements_line_friends do |t|
      t.references :site_measurement, null: false, foreign_key: true
      t.references :line_friend, null: false, foreign_key: true

      t.timestamps
    end
  end
end
