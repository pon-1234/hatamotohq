# frozen_string_literal: true

class AddInquiryInfoToReservationTable < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :stock, :integer, after: :room_name
    add_column :reservations, :stock_from, :datetime, after: :stock
    add_column :reservations, :stock_to, :datetime, after: :stock_from
  end
end
