# frozen_string_literal: true

class RenameMessageTypeOnAutoResponseMessages < ActiveRecord::Migration[6.0]
  def up
    rename_column :auto_response_messages, :message_type, :message_type_id
    execute <<-SQL
      ALTER TABLE auto_response_messages 
      ALTER COLUMN message_type_id TYPE integer 
      USING message_type_id::integer
    SQL
  end

  def down
    change_column :auto_response_messages, :message_type_id, :string
    rename_column :auto_response_messages, :message_type_id, :message_type
  end
end
