# frozen_string_literal: true

class RenameLineReplyTokenOnMessages < ActiveRecord::Migration[6.0]
  def change
    rename_column :messages, :line_reply_token, :reply_token
    rename_column :messages, :line_timestamp, :timestamp
  end
end
