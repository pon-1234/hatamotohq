# frozen_string_literal: true

class User::MediasController < User::ApplicationController
  def create
    @media = Media.new(media_params)
    @media.line_account = current_user.line_account
    if !@media.save
      render_bad_request_with_message(@media.first_error_message)
    end
  end

  private
    def media_params
      params.permit(
        :file
      )
    end
end
