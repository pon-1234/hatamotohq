# frozen_string_literal: true

class RemoveUnusedColumnOnAutoresponses < ActiveRecord::Migration[6.0]
  def up
    remove_column :auto_responses, :keyword
    remove_column :auto_responses, :keyword_status
  end

  def down
    add_column :auto_responses, :keyword, :string
    add_column :auto_responses, :keyword_status, :string
  end
end
