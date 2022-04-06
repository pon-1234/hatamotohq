# frozen_string_literal: true

class Api::V1::Staff::MediasController < Api::V1::Staff::ApplicationController
  authorize_resource
  before_action :check_content_type, only: :create

  # GET /api/v1/staff/medias
  def index
    @q = Media.accessible_by(current_ability).with_attached_file.ransack params[:q]
    @medias = @q.result.page(params[:page]).per 12
  end

  # POST /api/v1/staff/medias
  def create
    upload_media_validator = Api::V1::UploadMediaValidator.new(media_params.merge(duration: params[:duration]))
    unless upload_media_validator.valid?
      render_bad_request_with_message(upload_media_validator.errors.full_messages.first)
      return
    end
    @media = Media.new media_params
    @media.line_account = current_staff.line_account
    if @media.save
      @media.set_blob_duration(params[:duration]) if params[:duration].present?
      MediaConverter::AudioConverter.new(@media).perform
    elsif params[:file].content_type == 'audio/*' && @media.is_unknown_audio?
      @media.save validate: false
      @media.set_blob_duration(params[:duration]) if params[:duration].present?
      MediaConverter::AudioConverter.new(@media).perform
    else
      render_bad_request_with_message @media.first_error_message
    end
  end

  private
    def media_params
      params.permit :file, :type
    end

    # Fix error cann't upload ogg file from mobile side
    def check_content_type
      return unless params[:file].content_type == 'audio/*' && params[:file].original_filename.end_with?('.ogg')
      temp_file = params[:file].tempfile
      content_type_of_temp_file = MIME::Types.type_for(temp_file.path).first.content_type
      params[:file].content_type = 'audio/ogg' if content_type_of_temp_file == 'audio/ogg'
    end
end
