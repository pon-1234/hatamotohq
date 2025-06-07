# frozen_string_literal: true

class RemoveFlexMessagesTable < ActiveRecord::Migration[6.0]
  def up
    drop_table :flex_message_sent_logs
    drop_table :flex_messages
  end

  def down
    create_table :flex_messages do |t|
      t.references :line_account, foreign_key: true
      t.string :name
      t.json :json_message
      t.json :json_template
      t.text :html_template
      t.timestamps
      t.datetime :deleted_at
    end

    create_table :flex_message_sent_logs do |t|
      t.references :flex_message, foreign_key: true
      t.references :line_account, foreign_key: true
      t.text :html_template
      t.timestamps
    end
  end
end
