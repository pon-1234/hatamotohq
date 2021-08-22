class User::BroadcastsController < User::ApplicationController
  def index
  end

  def new
  end

  def create
    p '--------'
    p params
  end

  private
    def broadcast_params
      params.permit(
        :title,
        :
      )
    end
end
