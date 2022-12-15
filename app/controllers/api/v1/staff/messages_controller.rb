# frozen_string_literal: true

class Api::V1::Staff::MessagesController < Api::V1::Staff::ApplicationController
  before_action :find_channel

  # GET /api/v1/staff/channels/:channel_id/messages
  def index
    get_message_list_validator = Api::V1::GetMessageListValidator.new get_message_params
    unless get_message_list_validator.valid?
      render_bad_request_with_message get_message_list_validator.errors.full_messages.first
      return
    end
    @messages = message_finder.perform
  end

  # POST /api/v1/staff/channels/:channel_id/messages
  def create
    authorize! :create_message, @channel
    send_message_validator = Api::V1::SendMessageValidator.new(message_params[:message]
      &.as_json(only: Api::V1::SendMessageValidator::ATTRIBUTES)&.merge(current_staff: current_staff))
    unless send_message_validator.valid?
      render_bad_request_with_message send_message_validator.errors.full_messages.first
      return
    end
    @message = Messages::MessageBuilder.new(current_staff, @channel, message_params).perform
    success = push_message_to_line
    @message.update_columns status: success ? :sent : :error
  rescue CanCan::AccessDenied
    render_permission_denied
  rescue StandardError => e
    render_bad_request_with_message e.message
  end

  # POST /api/v1/staff/channels/:channel_id/messages/send_template
  def send_template
    authorize! :create_message, @channel
    send_template_validator = Api::V1::SendTemplateValidator.new(template_params.merge(current_staff: current_staff))
    unless send_template_validator.valid?
      render_bad_request_with_message send_template_validator.errors.full_messages.first
      return
    end
    template = Template.find template_params[:template_id]
    SendTemplateJob.perform_later @channel.id, template.id
    render_success
  end

  def send_scenario
    authorize! :create_message, @channel
    send_scenario_validator = Api::V1::SendScenarioValidator.new(scenario_params.merge(current_staff: current_staff))
    unless send_scenario_validator.valid?
      render_bad_request_with_message send_scenario_validator.errors.full_messages.first
      return
    end
    scenario = Scenario.find scenario_params[:scenario_id]
    ScenarioSchedulerJob.perform_later @channel.id, scenario.id
    render_success
  end

  private
    def find_channel
      @channel = current_staff.line_account.channels.find params[:channel_id]
    rescue
      render_bad_request_with_message t('errors.messages.channel_not_found')
    end

    def message_finder
      @message_finder ||= MessageFinder.new(@channel, params)
    end

    def message_params
      params.permit(:channel_id, :timestamp,
        message: [
          :type,
          :text,
          :packageId,
          :stickerId,
          :stickerResourceType,
          :originalContentUrl,
          :previewImageUrl,
          :duration
        ]
      )
    end

    def template_params
      params.permit :channel_id, :template_id
    end

    def scenario_params
      params.permit :channel_id, :scenario_id
    end

    def get_message_params
      params.permit :channel_id, :before
    end

    # Call line api to send the message to friend
    def push_message_to_line
      line_account = current_staff.line_account
      Normalizer::MessageNormalizer.new(@message.content, @channel.line_friend).perform
      LineApi::PushMessage.new(line_account).perform [@message.content], @channel.line_friend.line_user_id
    end
end
