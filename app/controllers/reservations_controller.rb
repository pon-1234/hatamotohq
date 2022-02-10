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

  # POST /reservations/callback/?notifierId=abc12-123acwab
  # When a bookmarked room becomes available, hotel management system
  # will send a notification via this URL with room information.
  def callback
    validator = SendAvailableRoomNotificationValidator.new(type_id: available_room_params['typeId'],
      available_room_count: available_room_params['plans']&.first.try(:[], 'planCalendar')&.first.try(:[], 'stock'),
      notifier_id: params['notifierId'])
    unless validator.valid?
      render_bad_request_with_message(validator.errors.full_messages.first)
      return
    end

    reservation = Reservation.wait.find_by(room_id: params[:type_id], notifier_id: params[:notifierId])
    AvailableRoomNotificationJob.perform_later available_room_params, reservation
    render_success
  end

  private
    def inquiry_params
      if params[:inquiry][:dateStart]
        params[:inquiry][:dateStart] = I18n.l(Date.strptime(params[:inquiry][:dateStart], '%Y年%m月%d日'), format: :hyphen)
      end
      if params[:inquiry][:dateEnd]
        params[:inquiry][:dateEnd] = I18n.l(Date.strptime(params[:inquiry][:dateEnd], '%Y年%m月%d日'), format: :hyphen)
      end
      params
        .require(:inquiry)
        .permit(
          :friend_line_id,
          :capacity,
          :dateStart,
          :dateEnd
        )
    end

    def available_room_params
      @available_room_params ||= params.permit(:notifierId, :non_smoking, :pax_max, :pax_min, :type_id, :type_name, :ota_url,
        room_area: [:value, :unit], room_photos: [], plans: [:plan_name, plan_calendar: [:date, :price, :stock]])
      @available_room_params.to_h.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
    end
end
