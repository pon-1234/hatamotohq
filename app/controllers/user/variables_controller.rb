# frozen_string_literal: true

class User::VariablesController < User::ApplicationController
  include User::VariablesHelper

  # GET /user/variables
  def index
    if request.format.json?
      @folders = Folder.accessible_by(current_ability).type_variable
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/variables/new
  def new
  end

  # GET /user/variables/:id/edit
  def edit
  end

  # POST /user/variables
  def create
    @variable = build_variable(variable_params)
    unless @variable.save
      render_bad_request_with_message(@variable.first_error_message)
    end
  end

  # PATCH /user/variables/:id
  def update
  end

  private
    def variable_params
      params.permit(
        :folder_id,
        :name,
        :type,
        :default
      )
    end
end
