# frozen_string_literal: true

class AddRoleToAdminsTable < ActiveRecord::Migration[6.0]
  def up
    add_column :admins, :role, :string, after: :email
    remove_column :admins, :status
  end

  def down
    remove_column :admins, :role
    add_column :admins, :status, :string
  end
end
