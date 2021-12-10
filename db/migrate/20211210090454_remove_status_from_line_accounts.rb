# frozen_string_literal: true

class RemoveStatusFromLineAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_column :line_accounts, :status
  end
end
