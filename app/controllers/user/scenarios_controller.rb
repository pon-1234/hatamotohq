class User::ScenariosController < User::ApplicationController
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

  # GET /user/scenarios/new
  def new
  end

  # POST /user/scenarios
  def create
    @scenario = Scenario.new(scenario_params)
    @scenario.save!
    render 'user/scenarios/create_success.json.jbuilder'
  end

  # GET /user/scenarios/:id
  def edit
  end

  # PATCH /user/scenarios/:id
  def update
  end

  private
    def scenario_params
      params.permit(
        :title,
        :content,
        :mode,
        :time_base_type,
        :status,
        action: {},
        tags: []
      )
    end
end
