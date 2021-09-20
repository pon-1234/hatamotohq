# frozen_string_literal: true

class ChangeLastMessageToText < ActiveRecord::Migration[6.0]
  def change
    change_column :channels, :last_message, :string
  end
end
