# frozen_string_literal: true

class User::FoldersController < User::ApplicationController
  def create
    @folder = Folder.new(folder_params)
    @folder.line_account = current_user.line_account
    if @folder.save!
      render 'user/folders/create.json.jbuilder'
    else
      render_bad_request
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
