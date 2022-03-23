# frozen_string_literal: true

class CreateAllowlistedJwts < ActiveRecord::Migration[6.0]
  def change
    create_table :allowlisted_jwts do |t|
      t.string :jti
      t.datetime :exp
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :allowlisted_jwts, :jti, unique: true
  end
end
