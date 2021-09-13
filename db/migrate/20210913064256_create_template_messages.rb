# frozen_string_literal: true

class CreateTemplateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :template_messages do |t|
      t.references :template, foreign_key: true
      t.json :content
      t.string :type
      t.integer :order, default: 0
      t.timestamps
    end
  end
end
