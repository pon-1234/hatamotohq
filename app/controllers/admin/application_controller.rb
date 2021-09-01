# frozen_string_literal: true

class Admin::ApplicationController < ActionController::Base
  layout 'admin/application'

  include ResponseHelper

  rescue_from ActionController::InvalidAuthenticityToken, with: :not_authenticated
  rescue_from CanCan::AccessDenied do |_exception|
    render file: "#{Rails.root}/public/403.html", status: 403, layout: false
  end

  before_action :authenticate_admin!

  def not_authenticated
    sign_out
    redirect_to new_admin_session_path, alert: 'ログインしてください'
  end

  def authenticate_admin!
    super
    # For authenticating websocket connection
    cookies.signed[:admin_id] = current_admin.id
  end
end
