# frozen_string_literal: true

class AddFromToMessages < ActiveRecord::Migration[6.0]
  def up
    remove_column :messages, :attr
    remove_column :messages, :is_bot_sender
    remove_column :messages, :slug
    add_column :messages, :from, :string, length: 32, after: :type
    add_column :messages, :text, :text, after: :from
  end

  def down
    add_column :messages, :attr, :string
    add_column :messages, :is_bot_sender, :boolean
    add_column :messages, :slug, :text
    remove_column :messages, :from
    remove_column :messages, :text
  end
end
