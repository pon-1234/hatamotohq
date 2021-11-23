# frozen_string_literal: true

class ChangeDescriptionColumnDataTypeToText < ActiveRecord::Migration[6.0]
  def change
    change_column :scenarios, :description, :text
  end
end
