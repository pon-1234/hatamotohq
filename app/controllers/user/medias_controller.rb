# frozen_string_literal: true

class User::MediasController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_media, only: [:variant]

  # GET /user/medias
  def index
    @q = Media.accessible_by(current_ability).with_attached_file.ransack(params[:q])
    @medias = @q.result.page(params[:page]).per(12)
    respond_to do |format|
      format.html
      format.json
    end
  end

  # POST /user/medias
  def create
    @media = Media.new(media_params)
    @media.line_account = current_user.line_account
    if @media.save
      @media.set_blob_duration(params[:duration]) if params[:duration].present?
    else
      render_bad_request_with_message(@media.first_error_message)
    end
  end

  # POST /user/medias/bulk_delete
  def bulk_delete
    ids = params[:ids]
    Media.where(id: ids).destroy_all
    render_success
  end

  # GET /user/medias/:id/content/:width
  def variant
    width = params[:width] || 1040
    data = open(@media.url)
    send_data data.read, filename: 'imagemap.png', type: @media.file.content_type, disposition: 'inline', stream: 'true', buffer_size: '4096' 
  end

  private
    def media_params
      params.permit(
        :file,
        :type
      )
    end

    def find_media
      @media = Media.find(params[:id])
    end
end
