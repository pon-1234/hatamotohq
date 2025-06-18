# frozen_string_literal: true

module Copyable
  extend ActiveSupport::Concern

  included do
    before_action :set_copyable_resource, only: [:copy]
  end

  def copy
    begin
      new_resource = duplicate_resource(@resource)
      
      if new_resource.save
        redirect_after_copy(new_resource)
      else
        flash[:error] = new_resource.errors.full_messages.join(', ')
        redirect_back(fallback_location: root_path)
      end
    rescue StandardError => e
      Rails.logger.error "Copy failed: #{e.message}"
      flash[:error] = t('errors.copy_failed')
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_copyable_resource
    @resource = resource_class.find(params[:id])
  end

  def duplicate_resource(original)
    new_resource = original.dup
    
    # Reset timestamps
    new_resource.created_at = nil
    new_resource.updated_at = nil
    
    # Add copy suffix to name if applicable
    if new_resource.respond_to?(:name)
      new_resource.name = "#{original.name} (Copy)"
    elsif new_resource.respond_to?(:title)
      new_resource.title = "#{original.title} (Copy)"
    end
    
    # Handle any model-specific duplication logic
    customize_duplicated_resource(new_resource, original) if respond_to?(:customize_duplicated_resource, true)
    
    new_resource
  end

  def redirect_after_copy(new_resource)
    flash[:success] = t('messages.copy_success')
    redirect_to after_copy_path(new_resource)
  end

  # Methods to be implemented in including controller
  def resource_class
    raise NotImplementedError, "You must define resource_class method"
  end

  def after_copy_path(resource)
    raise NotImplementedError, "You must define after_copy_path method"
  end
end