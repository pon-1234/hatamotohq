# frozen_string_literal: true

class CreateFlexTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :flex_templates do |t|
      t.string :type
      t.json :content
      t.timestamps
    end
  end
end
