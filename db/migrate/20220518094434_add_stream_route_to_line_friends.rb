# frozen_string_literal: true

class AddStreamRouteToLineFriends < ActiveRecord::Migration[6.0]
  def change
    add_reference :line_friends, :stream_route, null: true, foreign_key: true
  end
end
