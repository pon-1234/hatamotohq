# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  respond_to :html, :json
  layout 'auth'
  
  # Override create to add debugging
  def create
    Rails.logger.info "=== LOGIN ATTEMPT ==="
    Rails.logger.info "Request format: #{request.format}"
    Rails.logger.info "Request params: #{params.inspect}"
    Rails.logger.info "Request headers: #{request.headers.env.select { |k,v| k.match(/^HTTP_/) }.inspect}"
    
    super do |resource|
      if resource.persisted?
        Rails.logger.info "Login successful for user: #{resource.email}"
      else
        Rails.logger.info "Login failed"
      end
    end
  end

  protected

  def after_sign_in_path_for(user)
    user.admin? ? user_root_path : user_channels_path
  end

  private

  # DeviseがJSONレスポンスを返すための設定
  def respond_with(resource, _opts = {})
    Rails.logger.info "=== RESPOND_WITH called ==="
    Rails.logger.info "Resource: #{resource.inspect}"
    Rails.logger.info "Resource errors: #{resource.errors.full_messages}" if resource.respond_to?(:errors)
    
    if request.format.json?
      render json: {
        success: true,
        redirect_to: after_sign_in_path_for(resource)
      }, status: :ok
    else
      super
    end
  end

  def respond_to_on_destroy
    if request.format.json?
      head :no_content
    else
      super
    end
  end
end
