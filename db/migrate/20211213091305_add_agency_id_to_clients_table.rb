# frozen_string_literal: true

class AddAgencyIdToClientsTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :clients, :agency, foreign_key: { to_table: :agencies }, after: :id
    # Set default agency
    agency = Agency.first
    return if agency.nil?
    User.all.each do |user|
      next if user.client.present?
      client = Client.new
      client.name = user.company_name
      client.address = user.address
      client.phone_number = user.phone_number
      client.agency = agency
      client.save!
      client.reload
      user.client_id = client.id
      user.save!
      line_account = LineAccount.find_by(owner_id: user.id)
      if line_account.present?
        line_account.client = client
        line_account.save
      end
    end
  end
end
