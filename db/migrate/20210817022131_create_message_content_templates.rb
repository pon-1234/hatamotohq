# frozen_string_literal: true

class CreateMessageContentTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :message_content_templates do |t|
      t.references :message_template
      t.string :message_type
      t.longtext :content
      t.integer :num, default: 0
      t.timestamps
    end
  end
end
