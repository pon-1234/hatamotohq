# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :phone_number
      t.string :address
      t.string :status, default: 'active'
      t.timestamps
    end
  end
end
