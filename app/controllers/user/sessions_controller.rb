# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  layout 'auth'
  
  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?

    respond_to do |format|
      format.html { redirect_to after_sign_in_path_for(resource) }
      format.json do
        render json: {
          success: true,
          redirect_to: after_sign_in_path_for(resource)
        }, status: :ok
      end
    end
  end

  protected

  def after_sign_in_path_for(user)
    user.admin? ? user_root_path : user_channels_path
  end
end
