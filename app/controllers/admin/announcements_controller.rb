# frozen_string_literal: true

class Admin::AnnouncementsController < Admin::ApplicationController
  include Admin::AnnouncementsHelper

  before_action :find_announcement, only: [:show, :edit, :update, :destroy, :delete_confirm]

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
    if @announcement.destroy
      redirect_to admin_announcements_path, flash: { success: 'お知らせの削除は完了しました。' }
    else
      redirect_to admin_announcements_path, flash: { error: @announcement.first_error_message }
    end
  end

  def delete_confirm
    respond_to do |format|
      format.js
    end
  end

  def upload_image
    if params.has_key?(:file)
      file = params[:file]
      @blob = create_blob(file, file.original_filename, file.content_type)

      return render json: {
        url: url_for(@blob),
        name: file.original_filename,
        blob_id: @blob.id,
        exist_image: find_attachment_by_name_and_model('Announcement', file.original_filename).first.present?
      }
    end
    render_bad_request_with_message('Error params')
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
