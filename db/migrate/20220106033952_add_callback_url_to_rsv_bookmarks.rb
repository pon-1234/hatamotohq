# frozen_string_literal: true

class AddCallbackUrlToRsvBookmarks < ActiveRecord::Migration[6.0]
  def change
    add_column :rsv_bookmarks, :callback_url, :string, after: :room_id
  end
end
