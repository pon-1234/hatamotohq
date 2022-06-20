# frozen_string_literal: true

class AddSentAndVisitedToSitesLineFriends < ActiveRecord::Migration[6.0]
  def change
    add_column :sites_line_friends, :sent, :boolean, default: false
    add_column :sites_line_friends, :visited, :boolean, default: false

    add_column :site_measurements_line_friends, :sent, :boolean, default: false
    add_column :site_measurements_line_friends, :visited, :boolean, default: false
  end
end
