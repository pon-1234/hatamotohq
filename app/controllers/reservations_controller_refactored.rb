# frozen_string_literal: true

class ReservationsControllerRefactored < ApplicationController
  include ResponseHelper

  skip_before_action :verify_authenticity_token, only: :callback

  # GET /reservations/precheckin_form/:friend_line_id
  def precheckin_form
  end

  # GET /reservations/inquiry_form/:friend_line_id
  def inquiry_form
    @friend_line_id = params[:friend_line_id]
  end

  # POST /reservations/precheckin/:friend_line_id
  def precheckin
    friend = find_friend_by_line_id(params[:friend_line_id])
    service = Reservations::PrecheckinService.new(friend, precheckin_params)
    
    @precheckin_data = service.find_or_fetch_precheckin_data
    render :precheckin_detail_form
  end

  # POST /reservations/inquire/:friend_line_id
  def inquire
    service = Reservations::InquiryService.new(inquiry_params)
    
    if service.process
      redirect_to reservation_inquiry_success_path
    else
      flash[:error] = service.errors.join(', ')
      redirect_back(fallback_location: root_path)
    end
  end

  # POST /reservations/precheckin_detail
  def precheckin_detail
    friend = find_friend_by_line_id(params[:friend_line_id])
    service = Reservations::PrecheckinService.new(friend, precheckin_params)
    
    if service.create_or_update_precheckin
      send_success_message(friend, service.success_message)
      redirect_to reservation_precheckin_success_path
    else
      flash[:error] = service.errors.join(', ')
      redirect_back(fallback_location: root_path)
    end
  end

  # GET /reservations/inquiry_success
  def inquiry_success
  end

  # GET /reservations/precheckin_success
  def precheckin_success
  end

  # POST /reservations/callback?notifier_id=abc12-123acwab
  def callback
    service = Reservations::AvailableRoomNotificationService.new(
      available_room_params,
      params[:notifier_id]
    )
    
    if service.process
      render_success
    else
      render_bad_request_with_message(service.errors.first)
    end
  end

  private

  def precheckin_params
    params
      .require(:precheckin)
      .permit(ReservationPrecheckin::ATTRIBUTES)
  end

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
    @available_room_params ||= begin
      params.permit(
        :notifier_id, :paxMax, :paxMin, :id, :name, :otaUrl,
        :roomArea, :roomAreaUnit, :lineImage,
        labels: [],
        stockCalendar: [:date, :stock, :price]
      ).to_h
    end
  end

  def find_friend_by_line_id(line_id)
    LineFriend.find_by_line_user_id(line_id)
  end

  def send_success_message(friend, message)
    payload = {
      channel_id: friend.channel.id,
      messages: [{ 'text' => message, 'type' => 'text' }]
    }
    PushMessageToLineJob.perform_now(payload)
  end
end