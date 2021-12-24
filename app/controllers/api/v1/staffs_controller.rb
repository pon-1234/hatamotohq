# frozen_string_literal: true
Dir[File.join(__dir__, 'lib/yopaz', '*.rb')].each {|file| require file}

class Api::V1::StaffsController < Api::V1::BaseController
  before_action :authenticate_token!, only: :logout

  def login
    raise Yopaz::EmailNotPresent.new if params[:email].blank?
    raise Yopaz::PasswordNotPresent.new if params[:password].blank?
    staff = User.staff.find_by_email params[:email]
    raise Yopaz::StaffNotFound.new unless staff
    raise Yopaz::PasswordInvalid.new unless staff.valid_password?(params[:password])
    access_token = Yopaz::JwtProcessor.encode({staff_id: staff.id})
    render json: {status: 'success', data: {accessToken: access_token}}
  end

  def logout
    @staff.revocate_access_token(@token_payload['jti']) # include both check already logedout
    render json: {status: 'success'}
  end
end
