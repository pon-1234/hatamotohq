# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    events = events_params[:events]
    key = events_params[:key]
    return render_bad_request if events.blank? || key.blank?
    # only handle first event
    event = events.first
    WebhookHandler.new.handle_event(event, key)
    render_success
  rescue StandardError => e
    logger.error(e)
    render_server_error
  end

  def push
  end

  private
    def events_params
      params.permit(
        :key,
        events: [
          :type,
          :timestamp,
          :replyToken,
          :mode,
          postback: {},
          message: {},
          source: {},
        ]
      )
    end
end
