# frozen_string_literal: true

class ChangeContentToJsonOnAutoResponseMessages < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE auto_response_messages 
      ALTER COLUMN content TYPE json 
      USING content::json
    SQL
  end

  def down
    change_column :auto_response_messages, :content, :text
  end
end
