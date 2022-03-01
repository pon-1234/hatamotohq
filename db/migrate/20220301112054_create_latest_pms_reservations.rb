# frozen_string_literal: true

class CreateLatestPmsReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :latest_pms_reservations do |t|
      t.references :line_friend, null: false, foreign_key: true
      t.string :agency_booking_number
      t.string :agency_code
      t.string :agency_name
      t.string :agency_plan_code
      t.string :agency_plan_name
      t.string :booking_date
      t.string :booking_time
      t.integer :charge_claimed
      t.integer :charge_total
      t.string :charge_type
      t.string :check_in_date
      t.string :check_in_time
      t.string :check_out_date
      t.string :guest_name
      t.string :guest_kana
      t.string :pms_id
      t.text :insight_memo
      t.integer :nights
      t.text :order_memo
      t.string :payment
      t.string :prop_id
      t.json :room_list

      t.timestamps
    end
    add_index :latest_pms_reservations, :pms_id
  end
end
