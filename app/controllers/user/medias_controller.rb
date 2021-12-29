# frozen_string_literal: true

class User::MediasController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_media, only: [:variant]

  # GET /user/medias
  def index
    @q = Media.accessible_by(current_ability).with_attached_file.provider_system.ransack(params[:q])
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
