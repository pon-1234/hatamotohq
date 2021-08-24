# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  include WebhooksHelper

  def index
    events = params[:events]
    key = params[:key]
    return render_bad_request if events.blank? || key.blank?
    # only handle first event
    event = events.first
    if handle_event(event, key)
      render_success
    else
      render_server_error
    end
  end

  def push
    p '----hook push----'
  end

  private
    def events_params
      params.permit(events: [
        :type,
        :timestamp,
        :source,
        :replyToken,
        :mode
      ])
    end
end
