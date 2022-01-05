# frozen_string_literal: true

class ReservationsController < ApplicationController
  # GET /reservations/inquiry_form/:friend_line_id
  def inquiry_form
    @friend_line_id = params[:friend_line_id]
  end

  # POST /reservations/inquire/:friend_line_id
  def inquire
    ReservationInquiryJob.perform_later(inquiry_params)
    redirect_to reservation_inquiry_success_path
  end

  def inquiry_success
  end

  private
    def inquiry_params
      params
        .require(:inquiry)
        .permit(
          :friend_line_id,
          :name,
          :phone_number,
          :date
        )
    end
end
