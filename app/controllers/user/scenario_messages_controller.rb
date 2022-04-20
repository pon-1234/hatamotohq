# frozen_string_literal: true

class User::ScenarioMessagesController < User::ApplicationController
  before_action :find_scenario, only: [:index, :create, :update, :import]
  before_action :find_message, only: [:show, :update, :destroy, :delete_confirm]

  include User::ScenarioMessagesHelper

  # GET /user/scenarios/:scenario_id/messages
  def index
    if request.format.json?
      @messages = @scenario.scenario_messages.order(step: :asc).page(params[:page])
    end
    respond_to do |format|
      format.html do
        @testers = current_user.line_account.line_friends.is_tester
          .to_json(only: %i(id display_name))
      end
      format.json
    end
  end

  # GET /user/scenarios/:scenario_id/messages/:id
  def show
  end

  # GET /user/scenarios/:scenario_id/messages/new
  def new
    @scenario_id = params[:scenario_id]
  end

  # POST /user/scenarios/:scenario_id/messages
  def create
    @message = ScenarioMessage.new(message_params)
    @message.scenario = @scenario
    @message.site_measurements = [] if params[:notUseShorternUrl]
    if @message.save
      @scenario.reorder_messages
    else
      render_bad_request_with_message(@message.first_error_message)
    end
  end

  # GET /user/scenarios/:scenario_id/messages/:id/edit
  def edit
    @scenario_id = params[:scenario_id]
    @message_id = params[:id]
  end

  # PATCH /user/scenarios/:scenario_id/messages/:id
  def update
    @message.site_measurements.destroy_all if params[:notUseShorternUrl]
    if @message.update!(message_params)
      @scenario.reorder_messages
    else
      render_bad_request_with_message(@message.first_error_message)
    end
  end

  # POST /user/scenarios/:scenario_id/messages/import
  # Import scenario messages from message template
  def import
    template = Template.find(params[:template_id])
    import_messages_from_template(@scenario, template)
    @scenario.reorder_messages
    render_success
  end

  # DELETE /user/scenarios/:scenario_id/messages/:id
  def destroy
    @message.destroy!
    render_success
  end

  private
    def message_params
      params.permit(
        :id,
        :name,
        :is_initial,
        :date,
        :time,
        :order,
        :message_type_id,
        :status,
        content: {},
        site_measurements_attributes: [:id, :site_id, :site_name, :redirect_url]
      )
    end

    def find_scenario
      @scenario = Scenario.find(params[:scenario_id])
    end

    def find_message
      @message = ScenarioMessage.find(params[:id])
    end
end
