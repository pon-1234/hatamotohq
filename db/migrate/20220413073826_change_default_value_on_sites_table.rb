# frozen_string_literal: true

class ChangeDefaultValueOnSitesTable < ActiveRecord::Migration[6.0]
  def up
    rename_column :sites, :click_count_integer, :click_count
    
    execute <<-SQL
      ALTER TABLE sites 
      ALTER COLUMN sending_count TYPE integer 
      USING COALESCE(sending_count::integer, 0),
      ALTER COLUMN sending_count SET DEFAULT 0
    SQL
    
    execute <<-SQL
      ALTER TABLE sites 
      ALTER COLUMN click_count TYPE integer 
      USING COALESCE(click_count::integer, 0),
      ALTER COLUMN click_count SET DEFAULT 0
    SQL
    
    execute <<-SQL
      ALTER TABLE sites 
      ALTER COLUMN receiver_count TYPE integer 
      USING COALESCE(receiver_count::integer, 0),
      ALTER COLUMN receiver_count SET DEFAULT 0
    SQL
    
    execute <<-SQL
      ALTER TABLE sites 
      ALTER COLUMN visitor_count TYPE integer 
      USING COALESCE(visitor_count::integer, 0),
      ALTER COLUMN visitor_count SET DEFAULT 0
    SQL
  end

  def down
    rename_column :sites, :click_count, :click_count_integer
    change_column :sites, :sending_count, :integer
    change_column :sites, :click_count_integer, :string
    change_column :sites, :receiver_count, :integer
    change_column :sites, :visitor_count, :integer
  end
end
