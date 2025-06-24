# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  respond_to :html, :json
  layout 'auth'

  protected

  def after_sign_in_path_for(user)
    user.admin? ? user_root_path : user_channels_path
  end

  private

  # DeviseがJSONレスポンスを返すための設定
  def respond_with(resource, _opts = {})
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
