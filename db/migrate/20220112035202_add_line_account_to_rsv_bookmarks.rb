# frozen_string_literal: true

class AddLineAccountToRsvBookmarks < ActiveRecord::Migration[6.0]
  def change
    add_reference :rsv_bookmarks, :line_account, foreign_key: true
  end
end
