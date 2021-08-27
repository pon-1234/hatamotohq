# frozen_string_literal: true

class User::ScenarioMessagesController < User::ApplicationController
  before_action :find_scenario, only: [:index, :create]
  # GET /user/scenarios/:scenario_id/messages
  def index
    @messages = @scenario.scenario_messages.ordered.page(params[:page])
  end

  # GET /user/scenarios/:scenario_id/messages/new
  def new
    @scenario_id = params[:scenario_id]
  end

  # POST /user/scenarios/:scenario_id/messages
  def create
    @message = ScenarioMessage.new(message_params)
    @message.scenario = @scenario
    if @message.save
      render 'user/scenario_messages/create_success.json.jbuilder'
    else
      render_bad_request_with_message(@message.first_error_message)
    end
  end

  private
    def message_params
      params.permit(
        :name,
        :is_initial,
        :date,
        :time,
        :order,
        :message_type_id,
        content: {}
      )
    end

    def find_scenario
      @scenario = Scenario.find(params[:scenario_id])
    end
end
