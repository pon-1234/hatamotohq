# frozen_string_literal: true

class RenameColumnsOfRichMenuTables < ActiveRecord::Migration[6.0]
  def up
    rename_column :rich_menus, :line_chat_bar_text, :chat_bar_text
    rename_column :rich_menus, :is_active, :enabled
    remove_column :rich_menus, :title
  end

  def down
    rename_column :rich_menus, :chat_bar_text, :line_chat_bar_text
    rename_column :rich_menus, :enabled, :is_active
    add_column :rich_menus, :title, :string
  end
end
