# frozen_string_literal: true

class AddLogsToBroadcast < ActiveRecord::Migration[6.0]
  def change
    add_column :broadcasts, :logs, :text
  end
end
