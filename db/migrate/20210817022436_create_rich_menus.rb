# frozen_string_literal: true

class CreateRichMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :rich_menus do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :line_menu_id, comment: 'richMenuId'
      t.string :template_id
      t.string :name
      t.string :size
      t.string :title
      t.string :line_chat_bar_text, comment: 'chatBarText'
      t.string :selected
      t.mediumtext :areas
      t.string :status, default: 'pending'
      t.boolean :is_active
      t.datetime :start_at
      t.datetime :end_at
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
