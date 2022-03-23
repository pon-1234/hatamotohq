# frozen_string_literal: true

class AddStatusAndGuestPhoneNumberAndTagsToPmsReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :pms_reservations, :status, :string
    add_column :pms_reservations, :guest_phone_number, :string
    add_column :pms_reservations, :tags, :json
  end
end
