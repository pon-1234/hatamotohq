# frozen_string_literal: true

class AddConnectGgsheetConfigToSurvey < ActiveRecord::Migration[6.0]
  def change
    add_column :surveys, :sync_to_ggsheet, :boolean, after: :re_answer, default: false
    add_column :surveys, :connected_to_ggsheet, :boolean, after: :re_answer, default: false
  end
end
