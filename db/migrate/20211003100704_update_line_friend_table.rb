# frozen_string_literal: true

class UpdateLineFriendTable < ActiveRecord::Migration[6.0]
  def change
    add_column :line_friends, :locked, :boolean, default: false, after: :status
    add_column :line_friends, :visible, :boolean, default: true, after: :locked
  end
end
