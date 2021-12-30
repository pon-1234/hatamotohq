# frozen_string_literal: true

class AddHtmlContentToMessages < ActiveRecord::Migration[6.0]
  def up
    add_column :messages, :html_content, :text, after: :content
  end

  def down
    remove_column :messages, :html_content
  end
end
