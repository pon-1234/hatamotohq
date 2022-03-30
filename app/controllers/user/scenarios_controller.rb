# frozen_string_literal: true

class User::ScenariosController < User::ApplicationController
  load_and_authorize_resource except: :send_to_testers
  before_action :find_scenario, only: [:show, :update, :destroy, :delete_confirm, :copy, :send_to_testers]

  include User::ScenariosHelper

  # GET /user/scenarios
  def index
    if request.format.json?
      @params = params[:q]
      @q = Scenario.accessible_by(current_ability).includes([:tags]).ransack(params[:q])
      @scenarios = @q.result.page(params[:page]).per(8)
    end
    respond_to do |format|
      format.html do
        @testers = current_user.line_account.line_friends.is_tester
          .to_json(only: %i(id display_name))
      end
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
    @scenario.clone!
    render_success
  rescue
    render_bad_request
  end

  # GET /user/scenarios/manual
  def manual
    @scenarios = Scenario.accessible_by(current_ability).manual
  end

  # POST /user/scenarios/:id/send_to_testers
  def send_to_testers
    authorize! :send_to_testers, @scenario
    validator = SendScenarioToTestersValidator.new scenario_id: params[:id],
      line_friend_ids: params[:line_friend_ids]
    unless validator.valid?
      render_bad_request_with_message validator.errors.full_messages.first
      return
    end
    channel_ids = params[:line_friend_ids].map { |line_friend_id| LineFriend.find_by(id: line_friend_id).channel }
      .compact.map(&:id)
    ScenarioSendToTesterSchedulerJob.perform_later channel_ids, params[:id]
    render_success
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
