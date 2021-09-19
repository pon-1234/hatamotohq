# frozen_string_literal: true

class AddTargetToRichMenu < ActiveRecord::Migration[6.0]
  def change
    add_column :rich_menus, :target, :string, default: 'all', after: :status
    add_column :rich_menus, :conditions, :json, after: :target
  end
end
