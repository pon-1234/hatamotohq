# frozen_string_literal: true

class User::SurveysController < User::ApplicationController
  include User::SurveysHelper
  before_action :find_survey, only: [:show, :update, :destroy, :answered_users, :responses, :friend_responses, :copy, :toggle_status]
  # GET /user/surveys
  def index
    if request.format.json?
      @folders = Folder.accessible_by(current_ability).includes([:surveys]).type_survey
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/surveys/:id
  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/surveys/:id/answered_users
  def answered_users
    @answered_users = @survey.answered_users.page(params[:page]).per(10)
  end

  # GET /user/surveys/:id/responses
  def responses
    @responses = Kaminari.paginate_array(@survey.responses).page(params[:page]).per(10)
  end

  # GET /user/surveys/:id/:friend_id/:responses
  def friend_responses
    @survey_id = params[:id]
    @friend_id = params[:friend_id]
    @friend = LineFriend.find(@friend_id)
    if request.format.json?
      @responses = @survey.responses_by(@friend_id)
    end
    respond_to do |format|
      format.html
      format.json
    end
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

  # POST /user/surveys/:id/toggle_status
  def toggle_status
    @survey.toggle_status
    render_success
  end

  # POST /user/surveys/:id/copy
  def copy
    @survey.clone!
    render_success
  rescue => e
    logger.error e.message
    render_bad_request
  end

  # DELETE /user/surveys/:id
  def destroy
    @survey.destroy! if @survey.destroyable?
    render_success
  rescue
    render_bad_request
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
