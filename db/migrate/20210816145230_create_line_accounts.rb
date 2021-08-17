# frozen_string_literal: true

class CreateLineAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :line_accounts do |t|
      t.references :line_customer, foreign_key: true
      t.string :_uid
      t.string :username, unique: true
      t.string :password
      t.string :role, default: 'admin'
      t.string :status, default: 'inactive'
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
