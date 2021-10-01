# frozen_string_literal: true

class RemoveUnusedColumnInChannels < ActiveRecord::Migration[6.0]
  def up
    remove_column :channels, :un_read
    remove_column :channels, :is_mute
    remove_column :channels, :is_pair_chat
  end

  def down
    add_column :channels, :un_read, :boolean
    add_column :channels, :is_mute, :boolean
    add_column :channels, :is_pair_chat, :boolean
  end
end
