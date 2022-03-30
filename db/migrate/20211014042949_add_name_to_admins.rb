# frozen_string_literal: true

class AddNameToAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :name, :string, after: :email
    add_column :admins, :status, :string, after: :name
  end
end
