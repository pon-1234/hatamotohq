# frozen_string_literal: true

class AddStatusToReminderEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :reminder_events, :status, :string, after: :episode_id
  end
end
