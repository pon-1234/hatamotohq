# frozen_string_literal: true

class Agency::ProfilesController < Agency::ApplicationController
  # GET /agency/profile/edit
  def edit; end

  # PATCH /agency/profile
  def update
    if !current_agency.update_with_password(agency_params.except([:email]))
      render_bad_request_with_message(current_agency.first_error_message)
    end
  end

  private
    def agency_params
      params.permit(
        :email,
        :name,
        :address,
        :phone_number,
        :current_password,
        :password,
        :password_confirmation
      )
    end
end
