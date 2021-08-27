# frozen_string_literal: true

class User::ScenariosController < User::ApplicationController
  before_action :find_scenario, only: [:show, :update]

  # GET /user/scenarios
  def index
    @params = params[:q]
    @q = Scenario.order(id: :desc).ransack(params[:q])
    @scenarios = @q.result.page(params[:page])
  end

  # GET /user/scenarios/search
  def search
    index
    render :index
  end

  # GET /user/scenarios/:id
  def show
    respond_to do |format|
      format.json { render 'user/scenarios/show_success.json.jbuilder' }
    end
  end

  # GET /user/scenarios/new
  def new
  end

  # POST /user/scenarios
  def create
    @scenario = Scenario.new(scenario_params)
    @scenario.line_account = current_user.line_account
    if @scenario.save
      render 'user/scenarios/create_success.json.jbuilder'
    else
      render_bad_request_with_message(@scenario.first_error_message)
    end
  end

  # GET /user/scenarios/:id
  def edit
    @scenario_id = params[:id]
  end

  # PATCH /user/scenarios/:id
  def update
  end

  private
    def scenario_params
      params.permit(
        :title,
        :description,
        :mode,
        :time_base_type,
        :status,
        action: {},
        tags: []
      )
    end

    def find_scenario
      @scenario = Scenario.find(params[:id])
    end
end
