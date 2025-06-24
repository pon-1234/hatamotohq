# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  # respond_to :html, :json
  # ↑ This line is not strictly necessary as Devise handles it.
  skip_before_action :verify_authenticity_token, if: :json_request?

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

  layout 'auth'

  protected

  def json_request?
    request.format.json?
  end

  def after_sign_in_path_for(user)
    user.admin? ? user_root_path : user_channels_path
  end

  # This is to customize the response for authentication failure for JSON requests.
  # Devise's failure app will redirect to the specified path.
  def auth_options
    { scope: resource_name, recall: "#{controller_path}#new" }
  end
end
