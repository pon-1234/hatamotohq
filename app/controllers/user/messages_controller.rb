# frozen_string_literal: true

class User::MessagesController < User::ApplicationController
  before_action :find_channel, only: [:index, :create]

  # GET /user/channels/:channel_id/messages
  def index
    @messages = @channel.messages.all.page(params[:page])
  end

  # POST /user/channels/:channel_id/messages
  def create
    user = Current.user
    mb = Messages::MessageBuilder.new(user, @channel, message_params)
    @message = mb.perform
  rescue StandardError => e
    render_could_not_create_error(e.message)
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
          :text
        ]
      )
    end
end
