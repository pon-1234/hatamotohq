# frozen_string_literal: true

class Agency::ProfilesController < Agency::ApplicationController
  # GET /agency/profile/edit
  def edit; end

  # PATCH /agency/profile
  def update
    if !current_agency.update(agency_params.except([:email]))
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
        :password,
        :password_confirmation
      )
    end
end
