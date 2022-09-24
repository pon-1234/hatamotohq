# frozen_string_literal: true

class AddSpreadsheetIdToSurvey < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :spreadsheet_id, :string, after: :ggapi_auth_tokens
  end
end
