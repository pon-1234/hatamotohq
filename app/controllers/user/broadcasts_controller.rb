# frozen_string_literal: true

class User::BroadcastsController < User::ApplicationController
  include User::BroadcastsHelper

  # GET /user/broadcasts
  def index
    @params = params[:q]
    @q = Broadcast.order(id: :desc).ransack(params[:q])
    @broadcasts = @q.result.page(params[:page])
  end

  # GET /user/broadcasts/search
  def search
    index
    render :index
  end

  # GET /user/broadcasts/:id
  def show
    @broadcast = Broadcast.find(params[:id])
    render 'user/broadcasts/show_success.json.jbuilder'
  end

  # GET /user/broadcasts/new
  def new
  end

  # GET /user/broadcasts/edit
  def edit
    @broadcast_id = params[:id]
  end

  # POST /user/broadcasts
  def create
    @broadcast = build_broadcast(broadcast_params)
    if @broadcast.save!
      build_broadcast_messages(@broadcast, broadcast_params[:broadcast_messages])
      DispatchBroadcastJob.perform_later(@broadcast.id) if @broadcast.deliver_now? && !@broadcast.status_draft?
      render 'user/broadcasts/create_success.json.jbuilder'
    else
      render_bad_request_with_error_message(@broadcast.error.full_messages.first)
    end
  rescue => e
    logger.error e.message
    render_bad_request
  end

  # PATCH /user/broadcasts/:id
  def update
    @broadcast = Broadcast.find(params[:id])
    return render_permission_denied unless @broadcast.editable?

    @broadcast = update_broadcast(@broadcast, broadcast_params)
    if @broadcast.save!
      build_broadcast_messages(@broadcast, broadcast_params[:broadcast_messages])
      DispatchBroadcastJob.perform_later(@broadcast.id) if @broadcast.deliver_now? && !@broadcast.status_draft?
      render 'user/broadcasts/update_success.json.jbuilder'
    else
    end
  rescue => e
    logger.error e.message
    render_bad_request
  end

  private
    def broadcast_params
      params.permit(
        :title,
        :type,
        :status,
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
