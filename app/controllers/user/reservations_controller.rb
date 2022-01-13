# frozen_string_literal: true

class User::ReservationsController < User::ApplicationController
  # GET /user/reservations
  def index
    if request.format.json?
      @reservations = Reservation.accessible_by(current_ability)
    end
    respond_to do |format|
      format.html
      format.json
    end
  end
end
