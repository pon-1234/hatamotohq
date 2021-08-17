# frozen_string_literal: true

class CreateAutoResponseMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :auto_response_messages do |t|
      t.references :auto_response, foreign_key: true
      t.text :content
      t.string :message_type
      t.timestamps
    end
  end
end
