# frozen_string_literal: true

class AddIsLastToReminderEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :reminder_events, :is_last, :boolean, after: :schedule_at, default: false
  end
end
