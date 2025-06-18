# frozen_string_literal: true

module Toggleable
  extend ActiveSupport::Concern

  included do
    before_action :set_toggleable_resource, only: [:toggle]
  end

  def toggle
    attribute = toggle_attribute
    
    if @resource.update(attribute => !@resource.send(attribute))
      respond_to do |format|
        format.json { render json: { status: 'success', value: @resource.send(attribute) } }
        format.html { redirect_back(fallback_location: root_path, notice: t('messages.toggle_success')) }
      end
    else
      respond_to do |format|
        format.json { render json: { status: 'error', errors: @resource.errors.full_messages }, status: :unprocessable_entity }
        format.html do
          flash[:error] = @resource.errors.full_messages.join(', ')
          redirect_back(fallback_location: root_path)
        end
      end
    end
  end

  private

  def set_toggleable_resource
    @resource = resource_class.find(params[:id])
  end

  # Methods to be implemented in including controller
  def resource_class
    raise NotImplementedError, "You must define resource_class method"
  end

  def toggle_attribute
    params[:attribute]&.to_sym || :enabled
  end
end