# frozen_string_literal: true

class ChangeColumnSelectedOfRichmenuToBoolean < ActiveRecord::Migration[6.0]
  def change
    change_column :rich_menus, :selected, :boolean
  end
end
