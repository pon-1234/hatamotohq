# frozen_string_literal: true

module User::SurveysHelper
  include CsvHelper

  def build_survey(params)
    survey = Survey.new(params)
    survey.line_account = Current.user.line_account
    survey
  end

  def convert_to_csv(survey)
    responses = survey.survey_responses
    responses.map { |response| response_to_row(response) }
  end

  def response_to_row(response)
    questions = response.survey.survey_questions
    question_titles = questions.pluck(:content).map { |x| x['text'] }
    answers = response.survey_answers.map{|x| x.norm_answer }
    headers = %w(id created_at answer_user_id answer_user_name) + question_titles
    data = [response.id, response.created_at, response.line_friend_id, response.line_friend_name] + answers
    [headers, data].transpose.to_h
  end
end
