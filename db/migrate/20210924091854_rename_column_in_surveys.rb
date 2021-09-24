class RenameColumnInSurveys < ActiveRecord::Migration[6.0]
  def change
    rename_column :surveys, :multiple_answers, :re_answer
  end
end
