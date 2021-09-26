# frozen_string_literal: true

module User::SurveysHelper
  def build_survey(params)
    survey = Survey.new(params)
    survey.line_account = Current.user.line_account
    survey
  end
end
