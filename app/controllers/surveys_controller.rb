# frozen_string_literal: true

class SurveysController < ApplicationController
  before_action :find_survey, only: [:show, :answer]

  include SurveysHelper

  # GET /surveys/:code
  def show
    @survey = Survey.find_by(code: params[:code])
  end

  # GET /surveys/:code/:friend_id
  def form
    @code = params[:code]
    @friend_id = params[:friend_id]
  end

  # POST /surveys/:code/:friend_id
  def answer
    build_answer(@survey, answer_params)
    render_success
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
end
