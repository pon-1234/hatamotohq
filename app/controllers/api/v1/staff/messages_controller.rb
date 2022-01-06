# frozen_string_literal: true

class Api::V1::Staff::MessagesController < Api::V1::Staff::ApplicationController
  before_action :find_channel

  # POST /api/v1/staff/channels/:channel_id/messages
  def create
    authorize! :create_message, @channel
    @message = Messages::MessageBuilder.new(current_staff, @channel, message_params).perform
    success = push_message_to_line
    @message.update_columns status: success ? :sent : :error
  rescue CanCan::AccessDenied
    render_permission_denied
  rescue StandardError => e
    render_could_not_create_error e.message
  end

  private
    def find_channel
      @channel = Channel.find params[:channel_id]
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

    # Call line api to send the message to friend
    def push_message_to_line
      line_account = current_staff.line_account
      LineApi::PushMessage.new(line_account).perform [@message.content], @channel.line_friend.line_user_id
    end
end
