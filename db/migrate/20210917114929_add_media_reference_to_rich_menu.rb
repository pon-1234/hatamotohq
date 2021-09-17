# frozen_string_literal: true

class AddMediaReferenceToRichMenu < ActiveRecord::Migration[6.0]
  def change
    add_reference :rich_menus, :media, foreign_key: true, after: :end_at
  end
end
