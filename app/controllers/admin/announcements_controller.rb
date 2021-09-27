# frozen_string_literal: true

class Admin::AnnouncementsController < Admin::ApplicationController
  include Admin::ActiveStorageHelper

  before_action :find_announcement, only: [:show, :edit, :update, :destroy, :delete_confirm]

  # GET /admin/announcements
  def index
    if request.format.json?
      @params = params[:q]
      @q = Announcement.ransack(@params)
      @announcements = @q.result.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /admin/announcements/search
  def search
    index
    render :index
  end

  # GET /admin/announcements/new
  def new
  end

  # POST /admin/announcements
  def create
    @announcement = Announcement.new(announcement_params)
    unless @announcement.save(validate: !@announcement.draft?)
      render_bad_request_with_message(@announcement.first_error_message)
    end
  end

  # GET /admin/announcements/:id
  def show
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
    @announcement.destroy!
    render_success
  end

  def upload_image
    if params.has_key?(:file)
      file = params[:file]
      @blob = create_blob_from_file(file)

      return render json: {
        url: url_for(@blob),
        name: file.original_filename
      }
    end
    render_bad_request
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
