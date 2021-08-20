class User::TagsController < User::ApplicationController
  before_action :find_tag, only: [:update, :destroy, :friends]

  def index
    respond_to do |format|
      format.html
      format.json { render 'user/tags/index.json.jbuilder' }
    end
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      render 'user/tags/tag.json.jbuilder'
    else
      render_bad_request
    end
  end

  def update
    if @tag.update(params.permit(:name))
      render 'user/tags/tag.json.jbuilder'
    else
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
    render 'user/tags/friends.json.jbuilder'
  end

  private
    def tag_params
      params.permit(:name, :folder_id)
    end

    def find_tag
      @tag = Tag.find(params[:id])
    end
end
