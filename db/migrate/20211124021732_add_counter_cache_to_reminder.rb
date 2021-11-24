# frozen_string_literal: true

class AddCounterCacheToReminder < ActiveRecord::Migration[6.0]
  def change
    add_column :reminders, :episodes_count, :integer, after: :name
  end
end
