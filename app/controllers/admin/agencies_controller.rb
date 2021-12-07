# frozen_string_literal: true

class Admin::AgenciesController < Admin::ApplicationController
  before_action :find_agency, only: [:edit, :update, :destroy]

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

  # GET /admin/agencies/:id/edit
  def edit
  end

  # PATCH /admin/agencies/:id
  def update
    if !@agency.update(agency_params.except([:email]))
      render_bad_request_with_message(@agency.first_error_message)
    end
  end

  # DELETE /admin/agencies/:id
  def destroy
    @agency.destroy!
    render_success
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

    def find_agency
      @agency = Agency.find(params[:id])
    end
end
