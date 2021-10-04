# frozen_string_literal: true

class User::FriendsController < User::ApplicationController
  load_and_authorize_resource :line_friend
  before_action :find_friend, only: [:update, :toggle_locked, :toggle_visible]
  include User::FriendsHelper

  # GET /user/friends
  def index
    @params = params[:q]
    @q = LineFriend.accessible_by(current_ability).ransack(@params)
    @line_friends = @q.result.page(params[:page])
    respond_to do |format|
      format.html
      format.json
    end
  end

  def search
    index
    render :index
  end

  # PATCH /user/friends/:id
  def update
    if @friend.update(update_friend_params)
      render_success
    else
      render_bad_request
    end
  end

  # GET /user/friends/:id
  def show
    @friend = LineFriend.find(params[:id])
    respond_to do |format|
      format.html
      format.json
    end
  end

  # POST /user/friends/:id/toggle_locked
  def toggle_locked
    if params[:locked]
      @friend.locked = params[:locked]
      @friend.save
    else
      @friend.toggle_locked
    end
  end

  # POST /user/friends/:id/toggle_visible
  def toggle_visible
    if params[:visible]
      @friend.visible = params[:visible]
      @friend.save
    else
      @friend.toggle_visible
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
