# frozen_string_literal: true

class CreateFlexMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :flex_messages do |t|
      t.references :line_account, foreign_key: true
      t.string :name
      t.json :json_message
      t.json :json_template
      t.text :html_template
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
