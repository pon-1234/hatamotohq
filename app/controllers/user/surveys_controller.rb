# frozen_string_literal: true

class User::SurveysController < User::ApplicationController
  include User::SurveysHelper
  before_action :find_survey, only: [:show, :update]
  # GET /user/surveys
  def index
    @folders = Folder.accessible_by(current_ability).type_survey
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/surveys/:id
  def show
  end

  # GET /user/surveys/new
  def new
  end

  # GET /user/surveys/:id/edit
  def edit
    @survey_id = params[:id]
  end

  # POST /user/surveys
  def create
    @survey = build_survey(survey_params)
    unless @survey.save(validate: !@survey.draft?)
      render_bad_request_with_message(@survey.first_error_message)
    end
  end

  # PATCH /user/surveys/:id
  def update
    @survey.assign_attributes(survey_params)
    unless @survey.save(validate: !@survey.draft?)
      render_bad_request_with_message(@survey.first_error_message)
    end
  end

  private
    def survey_params
      params.permit(
        :id,
        :folder_id,
        :name,
        :title,
        :description,
        :success_message,
        :re_answer,
        :status,
        survey_questions_attributes: [
          :id,
          :required,
          :type,
          content: {}
        ],
        after_action: {}
      )
    end

    def find_survey
      @survey = Survey.find(params[:id])
    end
end
