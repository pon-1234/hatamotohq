# frozen_string_literal: true

class User::ScenariosController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_scenario, only: [:show, :update, :destroy, :delete_confirm, :copy]

  include User::ScenariosHelper

  # GET /user/scenarios
  def index
    if request.format.json?
      @params = params[:q]
      @q = Scenario.accessible_by(current_ability).includes([:tags]).ransack(params[:q])
      @scenarios = @q.result.page(params[:page]).per(8)
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/scenarios/search
  def search
    index
    render :index
  end

  # GET /user/scenarios/:id
  def show
    respond_to do |format|
      format.json
    end
  end

  # GET /user/scenarios/new
  def new
  end

  # POST /user/scenarios
  def create
    @scenario = build_scenario(scenario_params)
    if !@scenario.save
      render_bad_request_with_message(@scenario.first_error_message)
    end
  end

  # GET /user/scenarios/:id
  def edit
    @scenario_id = params[:id]
  end

  # PATCH /user/scenarios/:id
  def update
    if !@scenario.update(update_params)
      render_bad_request_with_message(@scenario.first_error_message)
    end
  end

  # DELETE /user/scenarios/:id
  def destroy
    @scenario.destroy!
    render_success
  end

  # POST /user/scenarios/:id/copy
  def copy
    new_scenario = @scenario.clone
    if new_scenario.present?
      @scenario.scenario_messages&.each { |message| message.clone_to(new_scenario.id) }
      render_success
    else
      render_bad_request
    end
  rescue => e
    logger.error e.message
    render_bad_request
  end

  # GET /user/scenarios/manual
  def manual
    @scenarios = Scenario.accessible_by(current_ability).manual
  end

  private
    def scenario_params
      params.permit(
        :title,
        :description,
        :mode,
        :type,
        :status,
        tag_ids: [],
        after_action: {}
      )
    end

    def update_params
      scenario_params.except(:mode)
    end

    def find_scenario
      @scenario = Scenario.find(params[:id])
    end
end
