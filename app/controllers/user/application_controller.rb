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
  around_action :set_current_thread_user

  def not_authenticated
    sign_out
    redirect_to new_user_session_path, alert: 'ログインしてください'
  end

  def authenticate_user!
    super
    # For authenticating websocket connection
    cookies.signed[:user_id] = current_user.id
  end

  def set_current_thread_user
    Current.user = current_user
    begin
      yield
    ensure
      Current.reset
    end
  end

  def ensure_bot_initialized
    redirect_to user_bot_setup_path unless current_user.line_account.bot_initialized
  end
end
