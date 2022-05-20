# frozen_string_literal: true

class User::StreamRoutesController < User::ApplicationController
  def new
    @folder_options_for_select = current_user.client.line_account.folders.type_stream_route
      .select('id, name').to_json
  end

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

  private
    def stream_route_params
      params.permit(:name, :qr_title, :folder_id, :actions, :run_add_friend_actions, :always_run_actions)
    end
end
