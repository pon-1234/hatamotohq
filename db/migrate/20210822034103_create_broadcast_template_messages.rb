# frozen_string_literal: true

class CreateBroadcastTemplateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :broadcast_template_messages do |t|
      t.references :broadcast_template, foreign_key: true
      t.string :message_type
      t.longtext :content
      t.integer :sort_order, default: 0
      t.timestamps
    end
  end
end
