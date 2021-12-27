# frozen_string_literal: true

Dir[File.join(__dir__, 'lib/common', '*.rb')].each {|file| require file}

class Api::V1::Staff::ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from Common::ErrorHandle, with: :render_error_response

  protected
  def render_error_response error
    render json: error, serializer: ::ApiExceptionSerializer, status: error.status_code
  end

  def authenticate_token!
    raise Common::AccessTokenNil.new if params[:access_token].blank?
    @token_payload = Common::JwtProcessor.decode(params[:access_token])
    @staff = User.staff.find_by_id(@token_payload['staff_id'])
    raise Common::AccessTokenInvalid.new unless @staff
    raise Common::AlreadyLogedOut.new unless @staff.available_access_token?(@token_payload['jti'])
  end
end
