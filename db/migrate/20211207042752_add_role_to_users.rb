# frozen_string_literal: true

class AddRoleToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :role, :string, after: :email
    User.where(role: nil).update_all(role: :admin)
  end
end
