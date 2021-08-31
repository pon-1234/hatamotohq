# frozen_string_literal: true

class RenameMessageTypeOnAutoResponseMessages < ActiveRecord::Migration[6.0]
  def change
    rename_column :auto_response_messages, :message_type, :message_type_id
    change_column :auto_response_messages, :message_type_id, :integer
  end
end
