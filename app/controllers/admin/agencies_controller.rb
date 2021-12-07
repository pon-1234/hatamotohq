# frozen_string_literal: true

class Admin::AgenciesController < Admin::ApplicationController
  # GET /admin/agencies
  def index
    if request.format.json?
      @params = params[:q]
      @q = Agency.ransack(@params)
      @agencies = @q.result.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # POST /admin/agencies
  def create
    @agency = Agency.new(agency_params)
    if !@agency.save
      render_bad_request_with_message(@agency.first_error_message)
    end
  end

  private
    def agency_params
      params.permit(
        :email,
        :name,
        :password,
        :password_confirmation
      )
    end
end
