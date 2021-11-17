# frozen_string_literal: true

class AddPiecesCountToRichMenusTable < ActiveRecord::Migration[6.0]
  def change
    add_column :rich_menus, :pieces_count, :integer, after: :member_count, default: 0
  end
end
