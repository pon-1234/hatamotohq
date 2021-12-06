# frozen_string_literal: true

class Agency::ApplicationController < ActionController::Base
  layout 'agency/application'

  include ResponseHelper

  rescue_from ActionController::InvalidAuthenticityToken, with: :not_authenticated
  rescue_from CanCan::AccessDenied do |_exception|
    render file: "#{Rails.root}/public/403.html", status: 403, layout: false
  end

  before_action :authenticate_agency!

  def not_authenticated
    sign_out
    redirect_to new_agency_session_path, alert: 'ログインしてください'
  end

  def authenticate_agency!
    super
    # For authenticating websocket connection
    cookies.signed[:agency_id] = current_agency.id
  end

  def current_ability
    @current_ability ||= Agencybility.new(current_agency)
  end
end
