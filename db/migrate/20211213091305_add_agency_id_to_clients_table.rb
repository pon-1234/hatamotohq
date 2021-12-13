# frozen_string_literal: true

class AddAgencyIdToClientsTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :clients, :agency, foreign_key: { to_table: :agencies }, after: :id
    # Set default agency
    agency = Agency.first
    if agency.present?
      Client.update(agency_id: agency&.id)
    end
  end
end
