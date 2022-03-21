# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :load_friend_and_latest_pms_reservation, only: %i(confirm_reservation confirmed_reservation cancel_reservation)
  before_action :load_room_information, only: :confirm_reservation

  def new
    @friend_line_id = params[:friend_line_id]
  end

  def create
    ReservationContactJob.perform_later contact_params, params[:contact][:friend_line_id]
    redirect_to contact_result_path
  end

  def result; end

  def confirm_reservation; end

  def confirmed_reservation
    @latest_pms_reservation.status = 'confirmed'
    if @latest_pms_reservation.save
      ReservationMailer.contact_to_client(@friend, @latest_pms_reservation).deliver_later
    else
      @error_message = '新規予約はありません。'
    end
  end

  def cancel_reservation
    @latest_pms_reservation.destroy
    redirect_to confirm_reservation_result_contacts_path
  end

  def confirm_reservation_result; end

  private
    def contact_params
      hashed_params = params.require(:contact).permit(:name, :phone_number).to_h
      # rename phone_number key to phoneNumberPrimary
      hashed_params[:phoneNumberPrimary] = hashed_params.delete :phone_number
      hashed_params
    end

    def load_friend_and_latest_pms_reservation
      @friend = LineFriend.find_by_line_user_id params[:friend_line_id]
      @latest_pms_reservation = LatestPmsReservation.find_by_id params[:last_pms_reservation_id]
    end

    def load_room_information
      @room_information = ReservationContact::GetRoomForLatestReservation.new.perform @latest_pms_reservation
    end
end
