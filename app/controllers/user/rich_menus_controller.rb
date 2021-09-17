class User::RichMenusController < User::ApplicationController
  # GET /user/rich_menus
  def index
    @folders = Folder.accessible_by(current_ability).includes([:rich_menus]).type_rich_menu
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/rich_menus
  def new
  end

  # POST /user/rich_menus
  def create
  end

  # GET /user/rich_menus/:id
  def edit
  end

  # PATCH /user/rich_menus/:id
  def update
  end

  private
    def rich_menu_params
      
    end
end
