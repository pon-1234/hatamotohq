# frozen_string_literal: true

class ReservationsController < ApplicationController
  include ResponseHelper

  skip_before_action :verify_authenticity_token, only: :callback

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
    validator = SendAvailableRoomNotificationValidator.new(type_id: available_room_params[:type_id],
      stock_calendar: available_room_params.to_h[:stock_calendar], uid: params[:uid],
      crm_api_key: request.headers['Authorization'].to_s.split(' ').last)
    unless validator.valid?
      render_bad_request_with_message(validator.errors.full_messages.first)
      return
    end

    reservation = Reservation.wait.find_by(room_id: params[:type_id], callback_url: params[:uid])
    AvailableRoomNotificationJob.perform_later available_room_params.to_h, reservation
    render_success
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

    def available_room_params
      params.permit(:uid, :non_smoking, :pax_max, :pax_min, :type_id, :type_name, :ota_url,
        price_calendar: [:date, :price], room_area: [:value, :unit], room_photos: [],
        stock_calendar: [:date, :stock])
    end
end
