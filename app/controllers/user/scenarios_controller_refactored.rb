# frozen_string_literal: true

class User::ScenariosControllerRefactored < User::ApplicationController
  include Copyable
  include Toggleable
  
  before_action :set_scenario, only: [:show, :edit, :update, :destroy]

  def index
    @scenarios = current_line_account.scenarios.ordered
  end

  def show
  end

  def new
    @scenario = current_line_account.scenarios.build
  end

  def edit
  end

  def create
    @scenario = current_line_account.scenarios.build(scenario_params)
    
    if @scenario.save
      redirect_to user_scenario_path(@scenario), notice: t('messages.create_success')
    else
      render :new
    end
  end

  def update
    if @scenario.update(scenario_params)
      redirect_to user_scenario_path(@scenario), notice: t('messages.update_success')
    else
      render :edit
    end
  end

  def destroy
    @scenario.destroy
    redirect_to user_scenarios_path, notice: t('messages.destroy_success')
  end

  private

  def set_scenario
    @scenario = current_line_account.scenarios.find(params[:id])
  end

  def scenario_params
    params.require(:scenario).permit(:name, :description, :mode, :enabled, 
                                     :after_action, scenario_messages_attributes: [:id, :content, :step, :_destroy])
  end

  # For Copyable concern
  def resource_class
    Scenario
  end

  def after_copy_path(scenario)
    edit_user_scenario_path(scenario)
  end

  def customize_duplicated_resource(new_scenario, original)
    # Copy scenario messages
    original.scenario_messages.each do |message|
      new_message = message.dup
      new_message.created_at = nil
      new_message.updated_at = nil
      new_scenario.scenario_messages << new_message
    end
    
    # Reset some attributes
    new_scenario.enabled = false
  end

  # For Toggleable concern
  def toggle_attribute
    :enabled
  end
end