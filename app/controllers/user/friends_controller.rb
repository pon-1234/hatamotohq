# frozen_string_literal: true

class User::FriendsController < User::ApplicationController
  load_and_authorize_resource :line_friend
  before_action :find_friend, only: [:update, :toggle_locked, :toggle_visible, :reminders, :set_reminder, :variables]
  include User::FriendsHelper

  # GET /user/friends
  def index
    if request.format.json?
      @params = params[:q]
      # Normalize add friend date condition
      @params[:created_at_gteq] = @params[:created_at_gteq]&.to_date.beginning_of_day if @params[:created_at_gteq].present?
      @params[:created_at_lteq] = @params[:created_at_lteq]&.to_date.end_of_day if @params[:created_at_lteq].present?
      @q = LineFriend.accessible_by(current_ability).includes([:channel, :tags, :taggings]).ransack(@params)
      @friends = @q.result.page(params[:page])
    end
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

  # GET /user/friends/:id/reminders
  def reminders
    @remindings = @friend.channel.remindings.includes([:reminder]).order('remindings.id desc').limit(10)
  end

  # POST /user/friends/:id/set_reminder
  def set_reminder
    @reminding = @friend.set_reminder!(reminder_params[:reminder_id], reminder_params[:goal])
  end

  # GET /user/friends/:id/variables
  def variables
    @variables = @friend.variables
  end

  # GET /user/export
  def export
    @q = LineFriend.includes(:tags).accessible_by(current_ability).ransack(params[:q])
    line_friends = @q.result
    csv = Export::ExportLineFriendService.new line_friends_for_export(line_friends)
    send_data csv.perform_hash, filename: "Line_frients#{Time.zone.now.strftime('%Y-%m-%d_%H-%M')}.csv"
  end

  private
    def update_friend_params
      params.permit(
        :display_name,
        :note,
        :tester,
        tag_ids: []
      )
    end

    def reminder_params
      params.permit(
        :reminder_id,
        :goal
      )
    end

    def find_friend
      @friend = LineFriend.find(params[:id])
    end
end
