# frozen_string_literal: true

class AddMembersCountToRichmenu < ActiveRecord::Migration[6.0]
  def change
    add_column :rich_menus, :member_count, :integer, after: :media_id, default: 0
  end
end
