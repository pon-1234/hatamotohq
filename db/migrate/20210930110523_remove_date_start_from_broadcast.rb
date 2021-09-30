# frozen_string_literal: true

class RemoveDateStartFromBroadcast < ActiveRecord::Migration[6.0]
  def up
    remove_column :broadcasts, :date_start
  end

  def down
    add_column :broadcasts, :date_start, :datetime
  end
end
