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

  # GET /reservations/inquiry_success
  def inquiry_success
  end

  # POST /reservations/callback/:uid
  # When a bookmarked room becomes available, hotel management system
  # will send a notification via this URL with room information.
  def callback
    # TODO handle this
  end

  private
    def inquiry_params
      params
        .require(:inquiry)
        .permit(
          :friend_line_id,
          :pax_num,
          :date_begin
          # :date_end
        )
    end
end
