# frozen_string_literal: true

class CreateBasicSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :basic_settings do |t|
      t.references :line_account, foreign_key: true
      t.string :company_name
      t.string :address
      t.json :business_hours
      t.string :phone_number
      t.string :website
      t.string :email
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
