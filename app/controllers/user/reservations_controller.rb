# frozen_string_literal: true

class User::ReservationsController < User::ApplicationController
  # GET /user/reservations
  def index
    if request.format.json?
      @params = params[:q]
      @q = Reservation.accessible_by(current_ability).order(created_at: :desc).ransack(params[:q])
      @reservations = @q.result.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end
end
