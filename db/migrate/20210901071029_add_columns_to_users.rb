# frozen_string_literal: true

class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string, after: :encrypted_password
    add_column :users, :company_name, :string, after: :name
    add_column :users, :phone_number, :string, after: :company_name
    add_column :users, :address, :string, after: :phone_number
    add_column :users, :note, :text, after: :address
    add_column :users, :status, :string, after: :note, default: 'active'
  end
end
