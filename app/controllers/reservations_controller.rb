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

  # POST /reservations/callback?notifier_id=abc12-123acwab
  # When a bookmarked room becomes available, hotel management system
  # will send a notification via this URL with room information.
  def callback
    validator = SendAvailableRoomNotificationValidator.new(type_id: available_room_params['id'], notifier_id: params['notifier_id'])
    unless validator.valid?
      render_bad_request_with_message(validator.errors.full_messages.first)
      return
    end
    available_stock = available_room_params[:stockCalendar].pluck(:stock).min
    reservation = Reservation.wait.find_by(room_id: params[:id], notifier_id: params[:notifier_id])
    if reservation.nil? || reservation.stock > available_stock
      render_bad_request_with_message('Could not find the data or the stock is less than expected')
      return
    end
    AvailableRoomNotificationJob.perform_later available_room_params, reservation
    render_success
  end

  private
    def inquiry_params
      params
        .require(:inquiry)
        .permit(
          :friend_line_id,
          :num_room,
          :date_start,
          :date_end
        )
    end

    def available_room_params
      @available_room_params ||= params.permit(:notifier_id, :paxMax, :paxMin, :id, :name, :otaUrl,
        :roomArea, :roomAreaUnit, :lineImage, labels: [], stockCalendar: [:date, :stock, :price])
      @available_room_params.to_h.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
    end
end
