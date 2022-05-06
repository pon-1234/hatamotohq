# frozen_string_literal: true

class AddBannerUrlToSurvey < ActiveRecord::Migration[6.0]
  def up
    add_column :surveys, :banner_url, :string, after: :name
  end

  def down
    remove_column :surveys, :banner_url
  end
end
