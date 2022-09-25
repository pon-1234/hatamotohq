# frozen_string_literal: true

class AppendSurveyResponseToGoogleSheetJob < ApplicationJob
  queue_as :default

  def perform(response_id)
    response = SurveyResponse.find(response_id)
    survey = response.survey
    # Init gooogle service
    sheets = Google::Apis::SheetsV4::SheetsService.new
    sheets.authorization = survey.ggapi_auth_tokens['access_token']

    questions = survey.survey_questions
    answers = response.survey_answers.map { |x| x.norm_answer }
    data = [response.id, response.created_at, response.line_friend_id, response.line_friend_name] + answers
    values = [
      data
    ]
    value_range = Google::Apis::SheetsV4::ValueRange.new(values: values)
    result = sheets.append_spreadsheet_value(survey.spreadsheet_id,
                                              "A1:A#{data.size}",
                                              value_range,
                                              value_input_option: 'RAW')
  end
end
