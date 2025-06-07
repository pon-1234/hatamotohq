# frozen_string_literal: true

class ChangeLastMessageOfChannelToJson < ActiveRecord::Migration[6.0]
  def up
    execute <<-SQL
      ALTER TABLE channels 
      ALTER COLUMN last_message TYPE json 
      USING last_message::json
    SQL
  end

  def down
    change_column :channels, :last_message, :text
  end
end
