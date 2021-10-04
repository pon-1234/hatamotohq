# frozen_string_literal: true

class AddDurationToMediaTable < ActiveRecord::Migration[6.0]
  def up
    add_column :active_storage_blobs, :duration, :float, after: :byte_size
    remove_column :media, :alias
  end

  def down
    add_column :media, :alias, :string
    remove_column :active_storage_blobs, :duration
  end
end
