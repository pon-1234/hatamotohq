# frozen_string_literal: true

class AddTesterToLineFriends < ActiveRecord::Migration[6.0]
  def change
    add_column :line_friends, :tester, :boolean, default: false
    add_index :line_friends, :tester
  end
end
