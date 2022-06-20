# frozen_string_literal: true

class ChangeDefaultValueOnSitesTable < ActiveRecord::Migration[6.0]
  def up
    rename_column :sites, :click_count_integer, :click_count
    change_column :sites, :sending_count, :integer, default: 0
    change_column :sites, :click_count, :integer, default: 0
    change_column :sites, :receiver_count, :integer, default: 0
    change_column :sites, :visitor_count, :integer, default: 0
  end

  def down
    rename_column :sites, :click_count, :click_count_integer
    change_column :sites, :sending_count, :integer
    change_column :sites, :click_count_integer, :string
    change_column :sites, :receiver_count, :integer
    change_column :sites, :visitor_count, :integer
  end
end
