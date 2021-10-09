# frozen_string_literal: true

class CreateReminderEpisodes < ActiveRecord::Migration[6.0]
  def change
    create_table :reminder_episodes do |t|
      t.references :reminder, foreign_key: true
      t.boolean :is_initial
      t.integer :date
      t.string :time
      t.json :actions
      t.json :messages
      t.timestamps
    end
  end
end
