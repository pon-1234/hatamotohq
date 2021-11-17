# frozen_string_literal: true

class User::RichMenusController < User::ApplicationController
  load_and_authorize_resource

  before_action :find_rich_menu, only: [:show, :update, :destroy]
  include User::RichMenusHelper

  # GET /user/rich_menus
  def index
    @folders = Folder.accessible_by(current_ability).includes([rich_menus: [media: :file_attachment]]).type_rich_menu
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
    if @rich_menu.update(rich_menu_params)
      DispatchRichMenuJob.perform_later(@rich_menu.id)
    else
      render_bad_request_with_message(@rich_menu.first_error_message)
    end
  end

  # DELETE /user/rich_menus/:id
  def destroy
    @rich_menu.destroy!
    render_success
  end

  # POST /user/rich_menus/:id/copy
  def copy
    rich_menu = @rich_menu.clone!
    if rich_menu.present?
      render_success
    else
      render_bad_request
    end
  rescue => e
    logger.error e.message
    render_bad_request
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
        :pieces_count,
        :target,
        :selected,
        :status,
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
