# frozen_string_literal: true

class User::FoldersController < User::ApplicationController
  def create
    @folder = Folder.new(folder_params)
    @folder.line_account = Current.user.line_account
    if !@folder.save
      render_bad_request_with_message(@folder.first_error_message)
    end
  end

  private
    def folder_params
      params.permit(
        :name,
        :type
      )
    end
end
