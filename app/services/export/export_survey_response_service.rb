# frozen_string_literal: true

class Export::ExportSurveyResponseService < Export::ExportService
  FIXED_ATTRIBUTES = %w(id created_at answer_user_id answer_user_name).freeze

  def initialize(objects)
    @attributes = objects.first&.keys || FIXED_ATTRIBUTES
    @question_attributes = @attributes - FIXED_ATTRIBUTES
    @objects = objects
    @header = FIXED_ATTRIBUTES.map { |attr| I18n.t("header_csv.survey_response.#{attr}") } + @question_attributes
  end
end
