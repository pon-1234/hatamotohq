# frozen_string_literal: true

class User::RichMenusController < User::ApplicationController
  before_action :find_rich_menu, only: [:show, :update]
  include User::RichMenusHelper

  # GET /user/rich_menus
  def index
    @folders = Folder.accessible_by(current_ability).includes([rich_menus: [:media]]).type_rich_menu
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/rich_menus/:id
  def show
  end

  # GET /user/rich_menus
  def new
  end

  # POST /user/rich_menus
  def create
    @rich_menu = build_rich_menu(rich_menu_params)
    if @rich_menu.save
      DispatchRichMenuJob.perform_later(@rich_menu.id)
    else
      render_bad_request_with_message(@rich_menu.first_error_message)
    end
  end

  # GET /user/rich_menus/:id
  def edit
    @rich_menu_id = params[:id]
  end

  # PATCH /user/rich_menus/:id
  def update
    if @rich_menu.update(rich_menu_params.except(:target))
      DispatchRichMenuJob.perform_later(@rich_menu.id)
    else
      render_bad_request_with_message(@rich_menu.first_error_message)
    end
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
        :target,
        :selected,
        areas: [
          :key,
          bounds: {},
          action: {},
        ],
        conditions: [
          :type,
          data: {}
        ],
        size: {}
      )
    end

    def find_rich_menu
      @rich_menu = RichMenu.find(params[:id])
    end
end
