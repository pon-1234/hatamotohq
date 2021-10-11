# frozen_string_literal: true

class AddStatusToMessage < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :status, :string, after: :reply_token, default: 'sent'
  end
end
