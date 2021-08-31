# frozen_string_literal: true

class ChangeTitleToNameOnAutoResponseTable < ActiveRecord::Migration[6.0]
  def change
    rename_column :auto_responses, :title, :name
  end
end
