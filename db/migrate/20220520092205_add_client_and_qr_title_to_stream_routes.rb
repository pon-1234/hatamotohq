# frozen_string_literal: true

class AddClientAndQrTitleToStreamRoutes < ActiveRecord::Migration[6.0]
  def change
    add_reference :stream_routes, :client, null: false, foreign_key: true
    add_column :stream_routes, :qr_title, :string
  end
end
