# frozen_string_literal: true

class User::SurveysController < User::ApplicationController
  include User::SurveysHelper
  # GET /user/surveys
  def index
    @folders = Folder.accessible_by(current_ability).type_survey
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/surveys/:id/new
  def new
  end

  # POST /user/surveys
  def create
    @survey = build_survey(survey_params)
    unless @survey.save!
      render_bad_request_with_message(@survey.first_error_message)
    end
  end

  private
    def survey_params
      params.permit(
        :folder_id,
        :name,
        :title,
        :description,
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
end
