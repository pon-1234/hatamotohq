# frozen_string_literal: true

class CreateFlexMessageSentLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :flex_message_sent_logs do |t|
      t.references :flex_message, foreign_key: true
      t.references :line_account, foreign_key: true
      t.text :html_template
      t.timestamps
    end
  end
end
