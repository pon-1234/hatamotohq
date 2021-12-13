# frozen_string_literal: true

class AddClientToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :client, foreign_key: { to_table: :clients }, after: :id
    add_reference :line_accounts, :client, foreign_key: { to_table: :clients }, after: :id

    User.all.each do |user|
      next if user.client.present?
      client = Client.new
      client.name = user.company_name
      client.address = user.address
      client.phone_number = user.phone_number
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
