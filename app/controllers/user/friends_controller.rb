# frozen_string_literal: true

class User::FriendsController < User::ApplicationController
  before_action :find_friend, only: [:update]
  include User::FriendsHelper

  def index
    @params = params[:q]
    @q = LineFriend.ransack(params[:q])
    @line_friends = @q.result.page(params[:page])
  end

  def search
    index
    render :index
  end

  def update
    if @friend.update(update_friend_params)
      render_success
    else
      render_bad_request
    end
  end

  def show
    @friend = LineFriend.find(params[:id])
    respond_to do |format|
      format.html
      format.json
    end
  end

  private
    def update_friend_params
      params.permit(
        :display_name,
        :note,
        tag_ids: []
      )
    end

    def find_friend
      @friend = LineFriend.find(params[:id])
    end
end
