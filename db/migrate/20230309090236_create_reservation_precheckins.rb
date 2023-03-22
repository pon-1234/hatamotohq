# frozen_string_literal: true

class CreateReservationPrecheckins < ActiveRecord::Migration[6.0]
  def change
    create_table :reservation_precheckins do |t|
      t.string :name
      t.string :phone_number
      t.date :check_in_date
      t.string :address
      t.string :birthday
      t.string :companion
      t.integer :gender

      t.timestamps
    end
  end
end
