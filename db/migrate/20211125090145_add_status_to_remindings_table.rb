# frozen_string_literal: true

class AddStatusToRemindingsTable < ActiveRecord::Migration[6.0]
  def change
    add_column :remindings, :status, :string, default: :active, after: :goal
  end
end
