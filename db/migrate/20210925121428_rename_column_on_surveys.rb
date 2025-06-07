# frozen_string_literal: true

class RenameColumnOnSurveys < ActiveRecord::Migration[6.0]
  def up
    rename_column :survey_questions, :is_required, :required
    rename_column :survey_questions, :index, :order
    execute <<-SQL
      ALTER TABLE survey_questions 
      ALTER COLUMN content TYPE json 
      USING content::json
    SQL
    remove_column :surveys, :is_publish
    rename_column :surveys, :action, :after_action
    execute <<-SQL
      ALTER TABLE surveys 
      ALTER COLUMN after_action TYPE json 
      USING after_action::json
    SQL
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
