# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
  respond_to :html, :json
  skip_before_action :verify_authenticity_token, if: :json_request?

  layout 'auth'

  protected

  def json_request?
    request.format.json?
  end

  def after_sign_in_path_for(user)
    user.admin? ? user_root_path : user_channels_path
  end
end
