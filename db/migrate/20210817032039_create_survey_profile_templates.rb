class CreateSurveyProfileTemplates < ActiveRecord::Migration[6.0]
  def change
    create_table :survey_profile_templates do |t|
      t.references :line_account, foreign_key: true
      t.references :folder, foreign_key: true
      t.string :field_name
      t.string :description
      t.string :type
      t.string :status, default: 'enable'
      t.timestamps
    end
  end
end
