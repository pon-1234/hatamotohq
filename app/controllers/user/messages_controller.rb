# frozen_string_literal: true

class User::MessagesController < User::ApplicationController
  before_action :find_channel

  # GET /user/channels/:channel_id/messages
  def index
    @messages = @channel.messages.includes([:sender]).page(params[:page]).per(30)
  end

  # POST /user/channels/:channel_id/messages
  def create
    user = Current.user
    mb = Messages::MessageBuilder.new(user, @channel, message_params)
    @message = mb.perform
    payload = {
      channel_id: @channel.id,
      messages: [@message.line_content]
    }
    PushMessageToLineJob.perform_later(payload)
  rescue StandardError => e
    render_could_not_create_error(e.message)
  end

  # POST /user/channels/:channel_id/messages/send_scenario
  def send_scenario
    scenario = Scenario.find(scenario_params[:scenario_id])
    ScenarioSchedulerJob.perform_later(@channel.id, scenario.id)
    render_success
  end

  private
    def find_channel
      @channel = Channel.find(message_params[:channel_id])
    end

    def message_params
      params.permit(
        :channel_id,
        :timestamp,
        message: [
          :type,
          :text,
          :packageId,
          :stickerId,
          :stickerResourceType
        ]
      )
    end

    def scenario_params
      params.permit(
        :channel_id,
        :scenario_id
      )
    end
end
