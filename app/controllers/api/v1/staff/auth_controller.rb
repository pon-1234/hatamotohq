# frozen_string_literal: true

class Api::V1::Staff::AuthController < Api::V1::Staff::ApplicationController
  skip_before_action :authenticate_staff!, only: :login

  def login
    raise Common::EmailNotPresent.new if params[:email].blank?
    raise Common::PasswordNotPresent.new if params[:password].blank?
    staff = User.staff.find_by_email params[:email]
    raise Common::StaffNotFound.new unless staff
    raise Common::PasswordInvalid.new unless staff.valid_password?(params[:password])
    access_token = Common::JwtProcessor.encode({staff_id: staff.id})
    render json: {status: 'success', data: {accessToken: access_token}}
  end

  def logout
    @staff.revocate_access_token(@token_payload['jti']) # include both check already logedout
    render json: {status: 'success'}
  end
end
