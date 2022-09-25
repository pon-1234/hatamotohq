# frozen_string_literal: true

class AppendSurveyResponseToGoogleSheetJob < ApplicationJob
  queue_as :default

  def perform(survey_response)
    # TODO
  end
end
