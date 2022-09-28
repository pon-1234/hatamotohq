# frozen_string_literal: true

class ChangeCapacityToNumRoom < ActiveRecord::Migration[6.0]
  def change
    rename_column :reservation_inquiries, :capacity, :num_room
  end
end
