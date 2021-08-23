class User::BroadcastsController < User::ApplicationController
  include User::BroadcastsHelper

  def index
  end

  def new
  end

  def create
    ApplicationRecord.transaction do
      broadcast = build_broadcast(broadcast_params)
      if broadcast.save!
        build_broadcast_messages(broadcast, broadcast_params[:broadcast_messages])
        # TODO refactor me
        DispatchBroadcastJob.perform_later(broadcast.id)
        render_success
      end
    rescue => e
      logger.error e.message
      render_bad_request
    end
  end

  private
    def broadcast_params
      params.permit(
        :title,
        :type,
        :deliver_now,
        :date_start,
        conditions: {},
        tag_ids: [],
        broadcast_messages: [
          :message_type_id,
          content: {}
        ]
      )
    end
end
