# frozen_string_literal: true

class User::BroadcastsController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_broadcast, only: [:show, :update, :destroy]

  include User::BroadcastsHelper

  # GET /user/broadcasts
  def index
    @params = params[:q]
    @q = Broadcast.accessible_by(current_ability).includes([:tags, taggings: [:tag]]).order(id: :desc).ransack(params[:q])
    @broadcasts = @q.result.page(params[:page])
  end

  # GET /user/broadcasts/search
  def search
    index
    render :index
  end

  # GET /user/broadcasts/:id
  def show
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
    if @broadcast.save
      build_broadcast_messages(@broadcast, messages_params)
      DispatchBroadcastJob.perform_later(@broadcast.id) if @broadcast.deliver_now? && !@broadcast.draft?
    else
      render_bad_request_with_message(@broadcast.error.full_messages.first)
    end
  rescue => e
    logger.error e.message
    render_bad_request
  end

  # PATCH /user/broadcasts/:id
  def update
    return render_permission_denied unless @broadcast.editable?
    @broadcast = update_broadcast(@broadcast, broadcast_params)
    if @broadcast.save
      build_broadcast_messages(@broadcast, messages_params)
      DispatchBroadcastJob.perform_later(@broadcast.id) if @broadcast.deliver_now? && !@broadcast.draft?
    else
      render_bad_request_with_message(@broadcast.error.full_messages.first)
    end
  rescue => e
    logger.error e.message
    render_bad_request
  end

  # DELETE /user/scenarios/:id
  def destroy
    if @broadcast.destroyable? && @broadcast.destroy
      redirect_to user_broadcasts_path, flash: { success: '一斉配信の削除は成功しました。' }
    else
      redirect_to user_broadcasts_path, flash: { error: '一斉配信の削除は失敗しました。' }
    end
  end

  def delete_confirm
    respond_to do |format|
      format.js
    end
  end

  private
    def broadcast_params
      params.permit(
        :title,
        :type,
        :status,
        :deliver_now,
        :schedule_at,
        tag_ids: [],
        conditions: {},
      )
    end

    def messages_params
      params.require(:messages).map do |p|
        p.permit(:message_type_id, content: {})
      end
    end

    def find_broadcast
      @broadcast = Broadcast.find(params[:id])
    end
end
