# frozen_string_literal: true

class AddGoogleOauthToSurveys < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :sync_to_ggsheet, :boolean, after: :re_answer, default: false
    add_column :surveys, :connected_to_ggsheet, :boolean, after: :sync_to_ggsheet, default: false
    add_column :surveys, :google_oauth_code, :string, after: :connected_to_ggsheet
    add_column :surveys, :google_oauth_tokens, :json, after: :google_oauth_code
    add_column :surveys, :google_oauth_email, :string, after: :google_oauth_tokens
    add_column :surveys, :spreadsheet_id, :string, after: :google_oauth_email
  end
end
