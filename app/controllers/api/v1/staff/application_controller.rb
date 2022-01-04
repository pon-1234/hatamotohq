# frozen_string_literal: true

Dir[File.join(__dir__, 'lib/common', '*.rb')].each {|file| require file}

class Api::V1::Staff::ApplicationController < ActionController::Base
  include ResponseHelper
  
  protect_from_forgery with: :null_session

  before_action :authenticate_staff!

  rescue_from Common::ErrorHandle, with: :render_error_response
  rescue_from CanCan::AccessDenied, with: :render_permission_denied

  protected
  def render_error_response error
    render json: error, serializer: ::ApiExceptionSerializer, status: error.status_code
  end

  def authenticate_staff!
    raise Common::AccessTokenNil.new if request.headers['Authorization'].blank?
    @token_payload = Common::JwtProcessor.decode request.headers['Authorization'].split(' ').last
    @staff = User.staff.find_by_id(@token_payload['staff_id'])
    raise Common::AccessTokenInvalid.new unless @staff
    raise Common::AlreadyLogedOut.new unless @staff.available_access_token?(@token_payload['jti'])
  end

  def current_staff
    @current_staff ||= @staff
  end

  def current_ability
    @current_ability ||= UserAbility.new(current_staff)
  end
end
