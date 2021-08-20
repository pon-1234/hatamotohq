class User::LineFriendsController < User::ApplicationController
  include User::LineFriendsHelper

  def index
    @params = params[:q]
    @q = LineFriend.ransack(params[:q])
    @line_friends = @q.result.page(params[:page])
  end

  def search
    index
    render :index
  end

  def show
  end
end
