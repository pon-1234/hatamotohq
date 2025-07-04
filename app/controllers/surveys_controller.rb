# frozen_string_literal: true

class SurveysController < ApplicationController
  before_action :find_survey, only: [:show, :answer, :form, :answer_success]

  include SurveysHelper

  # GET /surveys/:code
  def show
    @survey = Survey.find_by(code: params[:code])
    if @survey.blank? || !@survey.published?
      render_bad_request
    end
  end

  # GET /surveys/:code/:friend_id
  def form
    @code = params[:code]
    @friend_id = params[:friend_id]
    friend = LineFriend.find_by(line_user_id: @friend_id)
    unless can_answer?(@survey, friend)
      return redirect_to root_path, flash: { warning: '回答フォームにアクセスできません。' }
    end

    redirect_if_already_answered
  end

  # POST /surveys/:code/:friend_id
  def answer
    build_answer(@survey, answer_params)
    redirect_to survey_answer_success_path(code: params[:code], friend_id: params[:friend_id])
  rescue
    redirect_to survey_answer_error_path(code: params[:code], friend_id: params[:friend_id])
  end

  # GET /surveys/:code/:friend_id/answer_success
  def answer_success
  end

  # GET /surveys/:code/:friend_id/answer_error
  def answer_error
  end

  # GET /surveys/:code/:friend_id/already_answer
  def already_answer
  end

  private
    def answer_params
      params.permit(
        :code,
        :friend_id,
        answers: [
          :id,
          :answer
        ]
      )
    end

    def find_survey
      @survey = Survey.find_by(code: params[:code])
    end

    def can_answer?(survey, friend)
      survey.present? and friend.present? and survey.published? and survey.line_account_id == friend.line_account_id
    end

    def redirect_if_already_answered
      friend = LineFriend.find_by(line_user_id: @friend_id, line_account_id: @survey.line_account)
      response = SurveyResponse.find_by(survey: @survey, line_friend_id: friend&.id)
      if !@survey.re_answer? && response.present?
        redirect_to survey_already_answer_path(code: params[:code], friend_id: params[:friend_id])
      end
    end
end
