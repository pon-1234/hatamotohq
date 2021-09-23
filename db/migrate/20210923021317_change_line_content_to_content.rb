# frozen_string_literal: true

class ChangeLineContentToContent < ActiveRecord::Migration[6.0]
  def change
    rename_column :messages, :line_content, :content
  end
end
