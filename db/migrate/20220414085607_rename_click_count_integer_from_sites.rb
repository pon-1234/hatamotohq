# frozen_string_literal: true

class RenameClickCountIntegerFromSites < ActiveRecord::Migration[6.0]
  def change
    rename_column :sites, :click_count_integer, :click_count
    change_column :sites, :click_count, :integer
  end
end
