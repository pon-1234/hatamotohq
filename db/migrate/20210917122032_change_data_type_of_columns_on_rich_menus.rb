# frozen_string_literal: true

class ChangeDataTypeOfColumnsOnRichMenus < ActiveRecord::Migration[6.0]
  def change
    change_column :rich_menus, :size, :json
    change_column :rich_menus, :areas, :json
  end
end
