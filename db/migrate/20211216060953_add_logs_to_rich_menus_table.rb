# frozen_string_literal: true

class AddLogsToRichMenusTable < ActiveRecord::Migration[6.0]
  def up
    add_column :rich_menus, :logs, :text
    remove_column :rich_menus, :start_at
    remove_column :rich_menus, :end_at
  end

  def down
    add_column :rich_menus, :start_at, :datetime
    add_column :rich_menus, :end_at, :datetime
    remove_column :rich_menus, :logs
  end
end
