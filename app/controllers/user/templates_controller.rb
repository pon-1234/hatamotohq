# frozen_string_literal: true

class User::TemplatesController < User::ApplicationController
  # GET /user/templates
  def index
    @folders = Folder.accessible_by(current_ability).includes([templates: [:template_messages]]).type_message_template
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/templates/search
  def search
    index
    render :index
  end

  # GET /user/templates/new
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  private
    def template_params
      params.permit(
        :title
      )
    end
end
