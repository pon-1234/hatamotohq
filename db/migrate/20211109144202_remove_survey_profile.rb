# frozen_string_literal: true

class RemoveSurveyProfile < ActiveRecord::Migration[6.0]
  def change
    drop_table :survey_profiles
  end
end
