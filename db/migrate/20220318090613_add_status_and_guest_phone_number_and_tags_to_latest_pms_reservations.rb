# frozen_string_literal: true

class AddStatusAndGuestPhoneNumberAndTagsToLatestPmsReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :latest_pms_reservations, :status, :string
    add_column :latest_pms_reservations, :guest_phone_number, :string
    add_column :latest_pms_reservations, :tags, :json
  end
end
