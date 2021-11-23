# frozen_string_literal: true

class AddFriendsCountToVariable < ActiveRecord::Migration[6.0]
  def change
    add_column :variables, :friends_count, :integer, default: 0, after: :default
    Variable.all.each do |variable|
      variable.refresh_friends_count
    end
  end
end
