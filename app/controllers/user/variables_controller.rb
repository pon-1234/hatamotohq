# frozen_string_literal: true

class User::VariablesController < User::ApplicationController
  before_action :find_variable, only: [:show, :update, :copy, :destroy]
  include User::VariablesHelper

  # GET /user/variables
  def index
    if request.format.json?
      @folders = Folder.accessible_by(current_ability)
        .includes([:variables]).references(:variables)
        .type_variable
        .where('variables.type = ?', params[:type])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/variables/:id
  def show
  end

  # GET /user/variables/new
  def new
  end

  # GET /user/variables/:id/edit
  def edit
    @variable_id = params[:id]
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
    unless @variable.update(variable_params)
      render_bad_request_with_message(@variable.first_error_message)
    end
  end

  # POST /user/variables/:id/copy
  def copy
    @variable.clone!
    render_success
  end

  # DELETE /user/variables/:id
  def destroy
    @variable.destroy!
    render_success
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

    def find_variable
      @variable = Variable.find(params[:id])
    end
end
