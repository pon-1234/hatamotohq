# frozen_string_literal: true

class User::ScenarioMessagesController < User::ApplicationController
  # GET /user/scenarios/:scenario_id/messages
  def index
    @params = params[:q]
    @q = ScenarioMessage.ransack(params[:q])
    @messages = @q.result.page(params[:page])
  end

  # GET /user/scenarios/:scenario_id/messages/new
  def new
    @scenario_id = params[:scenario_id]
  end

  # POST /user/scenarios/:scenario_id/messages
  def create

  end
end
