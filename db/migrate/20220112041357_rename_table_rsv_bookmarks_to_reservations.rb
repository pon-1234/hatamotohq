# frozen_string_literal: true

class RenameTableRsvBookmarksToReservations < ActiveRecord::Migration[6.0]
  def change
    rename_table :rsv_bookmarks, :reservations
  end
end
