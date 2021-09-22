# frozen_string_literal: true

class Admin::AnnouncementsController < Admin::ApplicationController
  before_action :find_announcement, only: [:edit, :update, :destroy, :delete_confirm]

  # GET /admin/announcements
  def index
    @params = params[:q]
    @q = Announcement.ransack(@params)
    @announcements = @q.result.page(params[:page])
  end

  # GET /admin/announcements/new
  def new
  end

  # POST /admin/announcements
  def create
    @announcement = Announcement.new(announcement_params)
    if !@announcement.save
      render_bad_request_with_message(@announcement.first_error_message)
    end
  end

  # GET /admin/announcements/:id/edit
  def edit
  end

  # PATCH /admin/announcements/:id
  def update
    if !@announcement.update(announcement_params)
      render_bad_request_with_message(@announcement.first_error_message)
    end
  end

  # DELETE /admin/announcements/:id
  def destroy
    if @announcement.destroy
      redirect_to admin_announcements_path, flash: { success: 'delete message' }
    else
      redirect_to admin_announcements_path, flash: { error: @announcement.first_error_message }
    end
  end

  def delete_confirm
    respond_to do |format|
      format.js
    end
  end

  private
    def announcement_params
      params.permit(
        :title,
        :body,
        :announced_at,
        :status
      )
    end

    def find_announcement
      @announcement = Announcement.find(params[:id])
    end
end
