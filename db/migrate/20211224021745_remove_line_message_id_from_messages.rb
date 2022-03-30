# frozen_string_literal: true

class RemoveLineMessageIdFromMessages < ActiveRecord::Migration[6.0]
  def up
    remove_column :messages, :line_message_id
  end

  def down
    add_column :messages, :line_message_id, :string
  end
end
