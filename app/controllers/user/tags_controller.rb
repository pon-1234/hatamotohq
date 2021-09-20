# frozen_string_literal: true

class User::TagsController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_tag, only: [:update, :destroy, :friends]

  def index
    @folders = Folder.accessible_by(current_ability).type_tag
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.line_account = Current.user.line_account
    if !@tag.save
      render_bad_request_with_message(@tag.first_error_message)
    end
  end

  def update
    if !@tag.update(params.permit(:name))
      render_bad_request
    end
  end

  def destroy
    @tag.destroy
    render_success
  end

  # GET /user/tags/:id/friends
  # Get all friends by tag
  def friends
    @friends = @tag.friends
  end

  private
    def tag_params
      params.permit(:name, :folder_id)
    end

    def find_tag
      @tag = Tag.find(params[:id])
    end
end
