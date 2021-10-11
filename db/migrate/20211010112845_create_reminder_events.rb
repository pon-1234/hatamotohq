# frozen_string_literal: true

class CreateReminderEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :reminder_events do |t|
      t.references :reminding, foreign_key: true
      t.references :episode, foreign_key: true
      t.datetime :schedule_at
      t.timestamps
    end
  end
end
