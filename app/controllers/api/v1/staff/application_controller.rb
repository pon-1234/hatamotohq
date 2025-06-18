# frozen_string_literal: true

Dir[File.join(__dir__, 'lib/common', '*.rb')].each { |file| require file }

class Api::V1::Staff::ApplicationController < ActionController::Base
  include ApiErrorHandler
  include ApiResponseHelper

  protect_from_forgery with: :null_session

  before_action :authenticate_staff!

  rescue_from Common::ErrorHandle, with: :render_custom_error
  rescue_from Common::AccessTokenNil, with: :handle_missing_token
  rescue_from Common::AccessTokenInvalid, with: :handle_invalid_token
  rescue_from Common::AlreadyLogedOut, with: :handle_logged_out

  protected
    def render_custom_error(error)
      respond_with_error(
        message: error.message || 'An error occurred',
        status: error.try(:status_code) || :bad_request,
        code: error.class.name.demodulize.underscore.upcase
      )
    end

    def handle_missing_token(error)
      respond_with_unauthorized(message: 'Access token is required')
    end

    def handle_invalid_token(error)
      respond_with_unauthorized(message: 'Invalid access token')
    end

    def handle_logged_out(error)
      respond_with_unauthorized(message: 'Session has expired. Please login again')
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
