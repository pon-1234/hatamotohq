# frozen_string_literal: true

class User::ApplicationController < ActionController::Base
  layout 'user/application'
  
  include ResponseHelper

  rescue_from ActionController::InvalidAuthenticityToken, with: :not_authenticated
  rescue_from CanCan::AccessDenied do |_exception|
    render file: "#{Rails.root}/public/403.html", status: 403, layout: false
  end

  before_action :authenticate_user!
  before_action :ensure_bot_initialized

  def not_authenticated
    sign_out
    redirect_to new_user_session_path, alert: 'ログインしてください'
  end

  def authenticate_user!
    super
    # cookies.signed[:user_id] = current_user.id
  end

  def ensure_bot_initialized
    redirect_to user_bot_setup_path unless current_user.line_account.bot_initialized
  end
end
