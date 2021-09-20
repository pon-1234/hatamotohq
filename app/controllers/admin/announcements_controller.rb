# frozen_string_literal: true

class Admin::AnnouncementsController < Admin::ApplicationController
  # GET /admin/announcements
  def index
  end

  # GET /admin/announcements/new
  def new
  end

  # POST /admin/announcements
  def create
  end

  # GET /admin/announcements/:id/edit
  def edit
  end

  # PATCH /admin/announcements/:id
  def update
  end

  # DELETE /admin/announcements/:id
  def destroy
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
end
