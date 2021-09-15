# frozen_string_literal: true

class AddTemplateMessagesCountToTemplate < ActiveRecord::Migration[6.0]
  def change
    add_column :templates, :template_messages_count, :integer, default: 0, after: :name
  end
end
