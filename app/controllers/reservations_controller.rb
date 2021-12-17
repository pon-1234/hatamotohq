# frozen_string_literal: true

class ReservationsController < ApplicationController
  # GET /reservations/inquiry_form/:friend_id
  def inquiry_form
  end

  # POST /reservations/inquire/:friend_id
  def inquire
    ReservationInquiryJob.perform_later(inquiry_params)
    redirect_to reservation_inquiry_success_path
  end

  def inquiry_success
  end

  private
    def inquiry_params
      params.permit(
        :name,
        :phone_number,
        :date
      )
    end
end
