# frozen_string_literal: true

class CreateVariables < ActiveRecord::Migration[6.0]
  def up
    create_table :variables do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :name
      t.string :type
      t.string :default
      t.timestamps
    end

    # Create default folder
    LineAccount.find_in_batches do |accounts|
      accounts.each do |account|
        Folder.create(name: '未分類', line_account: account, type: :variable)
      end
    end
  end

  def down
    Folder.where(type: :variable).destroy_all
    drop_table :variables
  end
end
