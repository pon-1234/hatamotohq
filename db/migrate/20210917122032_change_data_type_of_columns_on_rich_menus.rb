# frozen_string_literal: true

class ChangeDataTypeOfColumnsOnRichMenus < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE rich_menus 
      ALTER COLUMN size TYPE json 
      USING size::json
    SQL
    
    execute <<-SQL
      ALTER TABLE rich_menus 
      ALTER COLUMN areas TYPE json 
      USING areas::json
    SQL
  end

  def down
    change_column :rich_menus, :size, :text
    change_column :rich_menus, :areas, :text
  end
end
