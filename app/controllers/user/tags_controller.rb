# frozen_string_literal: true

class User::TagsController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_tag, only: [:update, :destroy]

  # GET /user/tags
  def index
    if request.format.json?
      @folders = Folder.includes([:tags]).accessible_by(current_ability).type_tag
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # POST /user/tags
  def create
    @tag = Tag.new(tag_params)
    @tag.line_account = Current.user.line_account
    if !@tag.save
      render_bad_request_with_message(@tag.first_error_message)
    end
  end

  # PATCH /user/tags/:id
  def update
    if !@tag.update(params.permit(:name))
      render_bad_request
    end
  end

  # DELETE /user/tags/:id
  def destroy
    @tag.destroy
    render_success
  end

  private
    def tag_params
      params.permit(:name, :folder_id)
    end

    def find_tag
      @tag = Tag.find(params[:id])
    end
end
