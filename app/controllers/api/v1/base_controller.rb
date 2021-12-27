# frozen_string_literal: true

require 'yopaz/error_handle'
class Api::V1::BaseController < ActionController::Base
  protect_from_forgery with: :null_session

  rescue_from Yopaz::ErrorHandle, with: :render_error_response

  protected
  def render_error_response error
    render json: error, serializer: ::ApiExceptionSerializer, status: 401
  end

  def authenticate_token!
    raise Yopaz::AccessTokenNil.new if params[:access_token].blank?
    @token_payload = Yopaz::JwtProcessor.decode(params[:access_token])
    @staff = User.staff.find_by_id(@token_payload['staff_id'])
    raise Yopaz::AccessTokenInvalid.new unless @staff
    raise Yopaz::AlreadyLogedOut.new unless @staff.available_access_token?(@token_payload['jti'])
  end
end
