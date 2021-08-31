# frozen_string_literal: true

class ChangeContentToJsonOnAutoResponseMessages < ActiveRecord::Migration[6.0]
  def change
    change_column :auto_response_messages, :content, :json
  end
end
