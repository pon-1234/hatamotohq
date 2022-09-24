# frozen_string_literal: true

class AddGgApiAuthcodeToSurveys < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :ggapi_auth_code, :string, after: :re_answer
    add_column :surveys, :ggapi_auth_tokens, :json, after: :ggapi_auth_code
  end
end
