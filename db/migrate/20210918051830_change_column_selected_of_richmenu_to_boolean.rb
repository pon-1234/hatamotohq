# frozen_string_literal: true

class ChangeColumnSelectedOfRichmenuToBoolean < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE rich_menus 
      ALTER COLUMN selected TYPE boolean 
      USING CASE 
        WHEN selected = 'true' OR selected = '1' THEN true
        WHEN selected = 'false' OR selected = '0' THEN false
        ELSE NULL
      END
    SQL
  end

  def down
    change_column :rich_menus, :selected, :string
  end
end
