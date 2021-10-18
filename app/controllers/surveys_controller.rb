class SurveysController < ApplicationController
  # GET /surveys/:code/:friend_id
  def form
    survey = Survey.find_by(code: params[:code])
    @survey_id = survey.id
    @friend_id = params[:friend_id]
  end

  # POST /surveys/:code/:friend_id
  def answer
  end
end
