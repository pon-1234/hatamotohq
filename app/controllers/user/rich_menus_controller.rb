# frozen_string_literal: true

class User::RichMenusController < User::ApplicationController
  include User::RichMenusHelper

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
    @rich_menu = build_rich_menu(rich_menu_params)
    unless @rich_menu.save
      render_bad_request_with_message(@rich_menu.first_error_message)
    end
  end

  # GET /user/rich_menus/:id
  def edit
  end

  # PATCH /user/rich_menus/:id
  def update
  end

  private
    def rich_menu_params
      params.permit(
        :folder_id,
        :media_id,
        :name,
        :chat_bar_text,
        :start_at,
        :end_at,
        :template_id,
        areas: [
          :key,
          bounds: {},
          action: {},
        ],
        size: {},
      )
    end
end
