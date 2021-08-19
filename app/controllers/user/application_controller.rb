# frozen_string_literal: true

class User::ApplicationController < ActionController::Base
  layout 'user/application'

  rescue_from ActionController::InvalidAuthenticityToken, with: :not_authenticated
  rescue_from CanCan::AccessDenied do |_exception|
    render file: "#{Rails.root}/public/403.html", status: 403, layout: false
  end

  before_action :authenticate_user!

  def not_authenticated
    sign_out
    redirect_to new_user_session_path, alert: 'ログインしてください'
  end

  def authenticate_user!
    super
    # cookies.signed[:user_id] = current_user.id
  end
end
