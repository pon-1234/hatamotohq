# frozen_string_literal: true

class User::BroadcastsController < User::ApplicationController
  include User::BroadcastsHelper

  def index
    @params = params[:q]
    @q = Broadcast.order(id: :desc).ransack(params[:q])
    @broadcasts = @q.result.page(params[:page])
  end

  def search
    index
    render :index
  end

  def new
  end

  def edit
    @broadcast_id = params[:id]
  end

  def create
    ApplicationRecord.transaction do
      @broadcast = build_broadcast(broadcast_params)
      if @broadcast.save!
        build_broadcast_messages(@broadcast, broadcast_params[:broadcast_messages])
        # TODO refactor me
        DispatchBroadcastJob.perform_later(@broadcast.id)
        render 'user/broadcasts/create_success.json.jbuilder'
      end
    rescue => e
      logger.error e.message
      render_bad_request_with_error_message(@broadcast.error.full_messages.first)
    end
  end

  private
    def broadcast_params
      params.permit(
        :title,
        :type,
        :deliver_now,
        :schedule_at,
        conditions: {},
        tag_ids: [],
        broadcast_messages: [
          :message_type_id,
          content: {}
        ]
      )
    end
end
