# frozen_string_literal: true

class Export::ExportSurveyResponseService < Export::ExportService
  CSV_ATTRIBUTE = %w(id created_at answer_user_id answer_user_name).freeze

  def initialize(objects)
    @attributes = CSV_ATTRIBUTE
    @objects = objects
    @header = CSV_ATTRIBUTE.map { |attr| I18n.t("header_csv.survey_response.#{attr}") }
  end
end
