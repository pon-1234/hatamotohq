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
    push_message_to_line
  rescue StandardError => e
    render_could_not_create_error(e.message)
  end

  # POST /user/channels/:channel_id/messages/send_scenario
  def send_scenario
    scenario = Scenario.find(scenario_params[:scenario_id])
    ScenarioSchedulerJob.perform_later(@channel.id, scenario.id)
    render_success
  end

  # POST /user/channels/:channel_id/messages/send_template
  def send_template
    template = Template.find(template_params[:template_id])
    SendTemplateJob.perform_later(@channel.id, template.id)
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

    def template_params
      params.permit(
        :channel_id,
        :template_id
      )
    end

    # Call line api to send the message to friend
    def push_message_to_line
      line_account = Current.user.line_account
      LineApi::PushMessage.new(line_account).perform([@message.line_content], @channel.line_friend.line_user_id)
    end
end
