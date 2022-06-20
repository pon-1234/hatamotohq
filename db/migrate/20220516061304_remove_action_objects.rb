# frozen_string_literal: true

class RemoveActionObjects < ActiveRecord::Migration[6.0]
  def change
    drop_table :action_objects
  end
end
