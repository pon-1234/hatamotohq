# frozen_string_literal: true

class CreatePostbackMappers < ActiveRecord::Migration[6.0]
  def change
    create_table :postback_mappers do |t|
      t.string :key, index: true
      t.json :value
      t.timestamps
    end
  end
end
