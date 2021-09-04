# frozen_string_literal: true

class ChangeLastMessageOfChannelToJson < ActiveRecord::Migration[6.0]
  def change
    change_column :channels, :last_message, :json
  end
end
