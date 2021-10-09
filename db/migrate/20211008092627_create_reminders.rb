# frozen_string_literal: true

class CreateReminders < ActiveRecord::Migration[6.0]
  def up
    create_table :reminders do |t|
      t.references :folder, foreign_key: true
      t.string :name
      t.timestamps
    end

    # Create default folder
    LineAccount.find_in_batches do |accounts|
      accounts.each do |account|
        Folder.create(name: '未分類', line_account: account, type: :reminder)
      end
    end
  end

  def down
    Folder.where(type: :reminder).destroy_all
    drop_table :reminders
  end
end
