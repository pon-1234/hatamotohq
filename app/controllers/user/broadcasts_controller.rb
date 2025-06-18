# frozen_string_literal: true

class User::BroadcastsControllerRefactored < User::ApplicationController
  load_and_authorize_resource
  before_action :find_broadcast, only: [:show, :update, :destroy, :copy]

  # GET /user/broadcasts
  def index
    if request.format.json?
      @params = params[:q]
      @q = Broadcast.accessible_by(current_ability)
                    .includes([:tags, taggings: [:tag]])
                    .order(id: :desc)
                    .ransack(params[:q])
      @broadcasts = @q.result.page(params[:page])
    end
    
    respond_to do |format|
      format.html
      format.json
    end
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
    builder_service = Broadcasts::BroadcastBuilderService.new(current_line_account, broadcast_params)
    @broadcast = builder_service.build
    
    if builder_service.errors.any?
      render_bad_request_with_message(builder_service.errors.first)
      return
    end
    
    if @broadcast.save
      process_messages_and_dispatch
    else
      render_bad_request_with_message(@broadcast.errors.full_messages.first)
    end
  end

  # PATCH /user/broadcasts/:id
  def update
    unless @broadcast.editable?
      render_permission_denied
      return
    end
    
    builder_service = Broadcasts::BroadcastBuilderService.new(current_line_account, broadcast_params)
    @broadcast = builder_service.update(@broadcast)
    
    if builder_service.errors.any?
      render_bad_request_with_message(builder_service.errors.first)
      return
    end
    
    if @broadcast.save
      process_messages_and_dispatch
    else
      render_bad_request_with_message(@broadcast.errors.full_messages.first)
    end
  end

  # POST /user/broadcasts/:id/copy
  def copy
    clone_service = Broadcasts::BroadcastCloneService.new(@broadcast)
    
    if clone_service.clone
      render_success_with_data(broadcast_id: clone_service.new_broadcast.id)
    else
      render_bad_request_with_message(clone_service.errors.first)
    end
  end

  # DELETE /user/broadcasts/:id
  def destroy
    unless @broadcast.destroyable?
      render_bad_request_with_message('This broadcast cannot be deleted')
      return
    end
    
    if @broadcast.destroy
      render_success
    else
      render_bad_request_with_message(@broadcast.errors.full_messages.first)
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
      conditions: {}
    )
  end

  def messages_params
    params.require(:messages).map do |p|
      p.permit(:message_type_id, content: {}).tap do |whitelisted|
        whitelisted[:site_measurements_attributes] = []
        (p[:site_measurements_attributes] || p[:site_measurements]).to_a.each_with_index do |site_measurement, index|
          whitelisted[:site_measurements_attributes][index] = site_measurement
          whitelisted.permit!
        end
      end
    end
  end

  def find_broadcast
    @broadcast = Broadcast.find(params[:id])
  end

  def process_messages_and_dispatch
    message_service = Broadcasts::BroadcastMessageBuilderService.new(
      @broadcast, 
      messages_params, 
      skip_shorten_url: params[:notUseShorternUrl]
    )
    
    unless message_service.build_messages
      render_bad_request_with_message(message_service.errors.first)
      return
    end
    
    dispatch_if_needed
    render_success
  end

  def dispatch_if_needed
    return if @broadcast.draft?
    
    dispatcher = Broadcasts::BroadcastDispatcherService.new(@broadcast)
    
    unless dispatcher.dispatch
      Rails.logger.error "Failed to dispatch broadcast: #{dispatcher.errors.join(', ')}"
    end
  end
end