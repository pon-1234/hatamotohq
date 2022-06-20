# frozen_string_literal: true

class RemoveCodeFromSites < ActiveRecord::Migration[6.0]
  def change
    remove_column :sites, :code, :string
  end
end
