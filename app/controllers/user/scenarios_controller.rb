# frozen_string_literal: true

class User::ScenariosController < User::ApplicationController
  load_and_authorize_resource
  before_action :find_scenario, only: [:show, :update, :destroy, :delete_confirm, :copy]

  include User::ScenariosHelper

  # GET /user/scenarios
  def index
    @params = params[:q]
    @q = Scenario.accessible_by(current_ability).order(id: :desc).ransack(params[:q])
    @scenarios = @q.result.page(params[:page])
  end

  # GET /user/scenarios/search
  def search
    index
    render :index
  end

  # GET /user/scenarios/:id
  def show
    respond_to do |format|
      format.json { render 'user/scenarios/show_success.json.jbuilder' }
    end
  end

  # GET /user/scenarios/new
  def new
  end

  # POST /user/scenarios
  def create
    @scenario = build_scenario(scenario_params)
    if @scenario.save!
      render 'user/scenarios/create_success.json.jbuilder'
    else
      render_bad_request_with_message(@scenario.first_error_message)
    end
  end

  # GET /user/scenarios/:id
  def edit
    @scenario_id = params[:id]
  end

  # PATCH /user/scenarios/:id
  def update
    if @scenario.update(scenario_params.except(:mode))
      render 'user/scenarios/update_success.json.jbuilder'
    else
      render_bad_request_with_message(@scenario.first_error_message)
    end
  end

  # DELETE /user/scenarios/:id
  def destroy
    if @scenario.destroy
      redirect_to user_scenarios_path, flash: { success: 'シナリオの削除は成功しました。' }
    else
      redirect_to user_scenarios_path, flash: { error: 'シナリオの削除は失敗しました。' }
    end
  end

  def delete_confirm
    respond_to do |format|
      format.js
    end
  end

  # POST /user/scenarios/:id/copy
  def copy
    new_scenario = @scenario.clone
    if new_scenario.present?
      @scenario.scenario_messages&.each { |message| message.clone_to(new_scenario.id) }
      redirect_to user_scenarios_path, flash: { success: 'シナリオのコビーは完了しました。' }
    else
      redirect_to user_scenarios_path, flash: { error: 'シナリオのコビーは失敗しました。' }
    end
  rescue => e
    logger.error e.message
    redirect_to user_scenarios_path, flash: { error: 'シナリオのコビーは失敗しました。' }
  end

  def copy_confirm
    respond_to do |format|
      format.js
    end
  end

  private
    def scenario_params
      params.permit(
        :title,
        :description,
        :mode,
        :type,
        :status,
        tags: [],
        after_action: {}
      )
    end

    def find_scenario
      @scenario = Scenario.find(params[:id])
    end
end
