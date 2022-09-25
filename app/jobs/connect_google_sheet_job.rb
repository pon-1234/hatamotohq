# frozen_string_literal: true

class ConnectGoogleSheetJob < ApplicationJob
  queue_as :default

  def perform(survey_id)
    @survey = Survey.find(survey_id)
    return if @survey.connected_to_ggsheet?

    result = GoogleApi::GetServiceTokens.new.perform(@survey.ggapi_auth_code)
    @survey.ggapi_auth_tokens = result
    create_survey_sheet

    @survey.connected_to_ggsheet = true
    @survey.save!
  end

  def create_survey_sheet
    return unless @survey.spreadsheet_id.nil?
    sheets = Google::Apis::SheetsV4::SheetsService.new
    sheets.authorization = @survey.ggapi_auth_tokens['access_token']
    spreadsheet = {
      properties: {
        title: @survey.name
      }
    }
    spreadsheet = sheets.create_spreadsheet(spreadsheet,
                                            fields: 'spreadsheetId')
    @survey.spreadsheet_id = spreadsheet.spreadsheet_id

    # Add sheet header
    question_titles = @survey.survey_questions.pluck('content').pluck('text')
    values = [
      [
        '回答ID',
        '回答日時',
        '回答者ID',
        '回答者名'
      ] + question_titles
    ]
    value_range = Google::Apis::SheetsV4::ValueRange.new(values: values)
    result = sheets.append_spreadsheet_value(@survey.spreadsheet_id,
                                              "A1:A#{4 + question_titles.size}",
                                              value_range,
                                              value_input_option: 'RAW')
  end
end
