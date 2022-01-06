# frozen_string_literal: true

class Api::V1::Staff::MediasController < Api::V1::Staff::ApplicationController
  load_and_authorize_resource

  # GET /api/v1/staff/medias
  def index
    @q = Media.accessible_by(current_ability).with_attached_file.ransack params[:q]
    @medias = @q.result.page(params[:page]).per 12
  end

  # POST /api/v1/staff/medias
  def create
    @media = Media.new media_params
    @media.line_account = current_staff.line_account
    if @media.save
      @media.set_blob_duration(params[:duration]) if params[:duration].present?
    else
      render_bad_request_with_message @media.first_error_message
    end
  end

  private
    def media_params
      params.permit :file, :type
    end
end
