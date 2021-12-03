# frozen_string_literal: true

class RemoveSurveyProfileTemplates < ActiveRecord::Migration[6.0]
  def up
    drop_table :survey_profile_templates if table_exists?(:survey_profile_templates)
  end

  def down
  end
end
