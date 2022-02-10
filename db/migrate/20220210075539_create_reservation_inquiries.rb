# frozen_string_literal: true

class CreateReservationInquiries < ActiveRecord::Migration[6.0]
  def change
    create_table :reservation_inquiries do |t|
      t.integer :capacity
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
