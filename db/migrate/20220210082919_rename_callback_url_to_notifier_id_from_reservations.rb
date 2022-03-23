# frozen_string_literal: true

class RenameCallbackUrlToNotifierIdFromReservations < ActiveRecord::Migration[6.0]
  def change
    rename_column :reservations, :callback_url, :notifier_id
  end
end
