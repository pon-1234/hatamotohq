# frozen_string_literal: true

class ReservationsController < ApplicationController
  include ResponseHelper

  skip_before_action :verify_authenticity_token, only: :callback

  # GET /reservations/precheckin_form/:friend_line_id
  def precheckin_form
    @friend_line_id = params[:friend_line_id]
  end

  # GET /reservations/inquiry_form/:friend_line_id
  def inquiry_form
    @friend_line_id = params[:friend_line_id]
  end

  # POST /reservations/precheckin/:friend_line_id
  def precheckin
    @friend_line_id = params[:friend_line_id]
    precheckin = ReservationPrecheckin.find_by(precheckin_params)
    if precheckin.present?
      @precheckin_data = precheckin.slice(:name, :phone_number, :check_in_date, :address, :age_group, :companion, :gender)
    else
      @precheckin_data = {
        phone_number: precheckin_params[:phone_number],
        check_in_date: precheckin_params[:check_in_date]
      }
      if reservation = get_reservation(precheckin_params)
        guestId = reservation['guestId']
        guest = InsightOpenApi::GetGuest.new.perform(guestId)
        @precheckin_data[:name] = guest['name']
        @precheckin_data[:address] = guest['address']
      end
    end
    render 'precheckin_detail_form'
  end

  # POST /reservations/inquire/:friend_line_id
  def inquire
    ReservationInquiryJob.perform_later(inquiry_params)
    redirect_to reservation_inquiry_success_path
  end

  # POST /reservations/precheckin_detail
  def precheckin_detail
    response1, response2 = [], []
    if reservation = get_reservation(precheckin_params)
      guestId = reservation['guestId']
      response1 = InsightOpenApi::UpdateGuest.new.perform(precheckin_params, guestId)
      reservation_id = reservation['id']
      response2 = InsightOpenApi::UpdateReservation.new.perform(precheckin_params, reservation_id)
    end
    friend = LineFriend.find_by line_user_id: params[:friend_line_id]
    channel_id = friend.channel.id
    if response1.nil? && response2.nil?
      messages = [{"text"=>I18n.t('messages.precheckin.failed'), "type"=>"text"}]
    else
      precheckin = ReservationPrecheckin.find_by(phone_number: precheckin_params[:phone_number], check_in_date: precheckin_params[:check_in_date])
      if precheckin.present?
        precheckin.update(precheckin_params)
        messages = [{"text"=>I18n.t('messages.precheckin.update_success'), "type"=>"text"}]
      else
        ReservationPrecheckin.create!(precheckin_params)
        messages = [{"text"=>I18n.t('messages.precheckin.create_success'), "type"=>"text"}]
      end
    end
    payload = {
      channel_id: channel_id,
      messages: messages
    }
    PushMessageToLineJob.perform_now(payload)
    redirect_to reservation_precheckin_success_path
  end

  # GET /reservations/inquiry_success
  def inquiry_success
  end

  # GET /reservations/inquiry_success
  def precheckin_success
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
    def precheckin_params
      params
        .require(:precheckin)
        .permit(
          :name,
          :phone_number,
          :check_in_date,
          :address,
          :age_group,
          :companion,
          :gender
        )
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
      @available_room_params ||= params.permit(:notifier_id, :paxMax, :paxMin, :id, :name, :otaUrl,
        :roomArea, :roomAreaUnit, :lineImage, labels: [], stockCalendar: [:date, :stock, :price])
      @available_room_params.to_h.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
    end

    def get_reservation(params)
      response = InsightOpenApi::SearchReservations.new.perform(params[:check_in_date], params[:phone_number])
      response.first if response.present?
    end
end
