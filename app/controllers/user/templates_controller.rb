# frozen_string_literal: true

class User::TemplatesController < User::ApplicationController
  before_action :find_template, only: [:show, :update, :destroy, :copy]
  include User::TemplatesHelper
  # GET /user/templates
  def index
    if request.format.json?
      @folders = Folder.accessible_by(current_ability).type_template_message
    end
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

  # GET /user/templates/:id
  def show
  end

  # GET /user/templates/new
  def new
  end

  # POST /user/templates
  def create
    @template = build_template(template_params)
    unless @template.save
      render_bad_request_with_message(@template.first_error_message)
    end
  end

  # GET /user/templates/:id/edit
  def edit
    @template_id = params[:id]
  end

  # PATCH /user/templates/:id
  def update
    unless @template.update!(template_params.except(:folder_id))
      render_bad_request_with_message(@template.first_error_message)
    end
  end

  # DELETE /user/templates/:id
  def destroy
    @template.destroy!
    render_success
  end

  # POST /user/templates/:id/copy
  def copy
    @template.clone
    render_success
  end

  private
    def template_params
      params.permit(
        :folder_id,
        :name,
        template_messages_attributes: [
          :id,
          :order,
          :message_type_id,
          content: {}
        ]
      )
    end

    def find_template
      @template = Template.find(params[:id])
    end
end
