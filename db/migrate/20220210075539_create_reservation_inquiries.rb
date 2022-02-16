# frozen_string_literal: true

class CreateReservationInquiries < ActiveRecord::Migration[6.0]
  def change
    create_table :reservation_inquiries do |t|
      t.integer :capacity
      t.date :date_start
      t.date :date_end

      t.timestamps
    end
  end
end
