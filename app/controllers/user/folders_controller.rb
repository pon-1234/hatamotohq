# frozen_string_literal: true

class User::FoldersController < User::ApplicationController
  before_action :find_folder, only: [:update, :destroy]

  # POST /user/folders
  def create
    @folder = Folder.new(create_params)
    @folder.line_account = Current.user.line_account
    if !@folder.save!
      render_bad_request_with_message(@folder.first_error_message)
    end
  end

  # PATCH /user/folders/:id
  def update
    @folder.update(update_params)
  end

  # DELETE /user/folders/:id
  def destroy
    @folder.destroy!
    render_success
  end

  private
    def create_params
      params.permit(
        :name,
        :type
      )
    end

    def update_params
      params.permit(
        :name
      )
    end

    def find_folder
      @folder = Folder.find(params[:id])
    end
end
