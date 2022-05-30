# frozen_string_literal: true

class User::StreamRoutesController < User::ApplicationController
  before_action :load_folders, only: %i(new edit)
  before_action :load_stream_route, only: %i(show edit update destroy copy)

  def index
    respond_to do |format|
      format.html
      format.json do
        @folders = Folder.accessible_by(current_ability).type_stream_route.includes([stream_routes: [:line_friends]])
      end
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json do
        @friends = @stream_route.line_friends.page(params[:page])
      end
    end
  end

  def new; end

  def create
    stream_route = StreamRoute.new(stream_route_params)
    stream_route.client_id = current_user.client_id
    respond_to do |format|
      format.html
      format.json do
        if stream_route.save
          render_success
        else
          render_bad_request_with_message(stream_route.errors.full_messages.first)
        end
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      format.html
      format.json do
        if @stream_route.update(stream_route_params)
          render_success
        else
          render_bad_request_with_message(@stream_route.errors.full_messages.first)
        end
      end
    end
  end

  def destroy
    @stream_route.destroy!
    render_success
  end

  def copy
    duplicated_stream_route = @stream_route.dup
    duplicated_stream_route.name = "#{duplicated_stream_route.name}（コピー）" 
    duplicated_stream_route.code = nil
    duplicated_stream_route.save
    render_success
  end

  private
    def stream_route_params
      params.permit(:name, :qr_title, :folder_id, :run_add_friend_actions, :always_run_actions).tap do |whitelisted|
        whitelisted[:actions] = []
        params[:actions].to_a.each_with_index do |action, index|
          whitelisted[:actions][index] = action
          whitelisted.permit!
        end
      end
    end

    def load_folders
      @folder_options_for_select = current_user.client.line_account.folders.type_stream_route
        .select('id, name').to_json
    end

    def load_stream_route
      @stream_route = StreamRoute.find params[:id]
    end
end
