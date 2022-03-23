# frozen_string_literal: true

class AddRoomNameToReservations < ActiveRecord::Migration[6.0]
  def up
    add_column :reservations, :room_name, :string, after: :room_id
  end

  def down
    remove_column :reservations, :room_name
  end
end
