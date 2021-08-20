class User::TagsController < User::ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render 'user/tags/index.json.jbuilder' }
    end
  end
end
