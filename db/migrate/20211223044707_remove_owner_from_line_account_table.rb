# frozen_string_literal: true

class RemoveOwnerFromLineAccountTable < ActiveRecord::Migration[6.0]
  def up
    remove_reference :line_accounts, :owner
  end

  def down
    add_reference :line_accounts, :owner, foreign_key: { to_table: :users }, after: :id
  end
end
