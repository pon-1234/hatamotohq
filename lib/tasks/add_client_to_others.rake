# frozen_string_literal: true

desc 'add client to other tables on production'
# Run:  rake add_client_to_others
task add_client_to_others: :environment do
  puts 'start ...'
  ApplicationRecord.transaction do
    new_agency = Agency.create! email: 'agency1@example.com', name: 'sample_agency', address: 'sample_address', phone_number: '1234567890',
      password: '123456789', password_confirmation: '123456789'
    clients = []
    LineAccount.where(client_id: nil).each_with_index do |line_account, index|
      new_client = Client.create! agency_id: new_agency.id, name: "sample_client_#{index + 1}", phone_number: '1234567890', address: 'sample_address',
        status: 'active'
      line_account.update! client_id: new_client.id
      clients << new_client
    end

    User.where(client_id: nil).each_with_index do |user, index|
      specify_client = clients[index]
      if specify_client
        user.update! client_id: specify_client.id
      else
        new_client = Client.create! agency_id: new_agency.id, name: "sample_client_#{index + 1}", phone_number: '1234567890', address: 'sample_address',
          status: 'active'
        user.update! client_id: new_client.id
      end
    end
  end

  puts 'done!'
end
