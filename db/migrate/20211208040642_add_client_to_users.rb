# frozen_string_literal: true

class AddClientToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :client, foreign_key: { to_table: :clients }, after: :id
  end
end
