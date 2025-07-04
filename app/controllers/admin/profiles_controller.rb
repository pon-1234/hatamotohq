# frozen_string_literal: true

class Admin::ProfilesController < Admin::ApplicationController
  # GET /admin/profile/edit
  def edit; end

  # PATCH /admin/profile
  def update
    if current_admin.update_with_password(account_params)
      render_success
    else
      render_bad_request_with_message(current_admin.first_error_message)
    end
  end

  private
    def account_params
      params.permit(
        :email,
        :name,
        :current_password,
        :password,
        :password_confirmation
      )
    end
end
