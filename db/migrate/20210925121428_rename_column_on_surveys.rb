# frozen_string_literal: true

class RenameColumnOnSurveys < ActiveRecord::Migration[6.0]
  def up
    rename_column :survey_questions, :is_required, :required
    rename_column :survey_questions, :index, :order
    change_column :survey_questions, :content, :json
    remove_column :surveys, :is_publish
    rename_column :surveys, :action, :after_action
    change_column :surveys, :after_action, :json
  end

  def down
    rename_column :survey_questions, :required, :is_required
    rename_column :survey_questions, :order, :index
    change_column :survey_questions, :content, :text
    add_column :surveys, :is_publish, :boolean
    change_column :surveys, :after_action, :text
    rename_column :surveys, :after_action, :action
  end
end
