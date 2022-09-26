# frozen_string_literal: true

class AddPmsApiKeyToLineAccounts < ActiveRecord::Migration[6.0]
  def change
    add_column :line_accounts, :pms_api_key, :string, after: :liff_id, nullable: true
  end
end
