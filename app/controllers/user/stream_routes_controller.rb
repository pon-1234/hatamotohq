class User::StreamRoutesController < User::ApplicationController
  def new; end

  def create
    stream_route = StreamRounte.new(stream_route_params)
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