# frozen_string_literal: true

class RemoveUnusedColumnInLineAccountTable < ActiveRecord::Migration[6.0]
  def up
    remove_column :line_accounts, :line_channel_access_token
  end

  def down
    add_column :line_accounts, :line_channel_access_token, :string
  end
end
