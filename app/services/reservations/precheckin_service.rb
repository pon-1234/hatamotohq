# frozen_string_literal: true

module Reservations
  class PrecheckinService
    attr_reader :friend, :params, :errors

    def initialize(friend, params)
      @friend = friend
      @params = params
      @errors = []
    end

    def find_or_fetch_precheckin_data
      if existing_precheckin = find_existing_precheckin
        existing_precheckin.slice(ReservationPrecheckin::ATTRIBUTES)
      else
        fetch_from_pms
      end
    end

    def create_or_update_precheckin
      return false unless valid?

      ActiveRecord::Base.transaction do
        update_pms_data if reservation_exists?
        save_precheckin_record
      end

      true
    rescue StandardError => e
      @errors << e.message
      false
    end

    def success_message
      @precheckin_exists ? I18n.t('messages.precheckin.update_success') : I18n.t('messages.precheckin.create_success')
    end

    private

    def find_existing_precheckin
      ReservationPrecheckin.find_by(
        phone_number: params[:phone_number],
        check_in_date: params[:check_in_date]
      )
    end

    def fetch_from_pms
      data = {
        phone_number: params[:phone_number],
        check_in_date: params[:check_in_date]
      }

      if reservation = find_reservation_in_pms
        data[:companion] = reservation['companion']
        
        if guest = fetch_guest_from_pms(reservation['guestId'])
          data.merge!(
            name: guest['name'],
            address: guest['address'],
            birthday: guest['birthday'],
            gender: guest['gender']
          )
        end
      end

      data
    end

    def find_reservation_in_pms
      return nil unless pms_api_key.present?

      reservation_info = {
        checkInFrom: params[:check_in_date],
        checkInTo: params[:check_in_date],
        guestPhoneNumber: params[:phone_number]
      }

      response = Pms::Reservation::SearchReservations.new(pms_api_key).perform(reservation_info)
      response&.first
    end

    def fetch_guest_from_pms(guest_id)
      return nil unless pms_api_key.present? && guest_id.present?

      Pms::Guest::GetGuests.new(pms_api_key).perform(guest_id)
    end

    def update_pms_data
      reservation = find_reservation_in_pms
      return unless reservation

      # Update guest information
      Pms::Guest::UpdateGuest.new(pms_api_key).perform(
        reservation['guestId'],
        params.slice(:birthday, :gender)
      )

      # Update reservation information
      Pms::Reservation::UpdateReservations.new(pms_api_key).perform(
        reservation['id'],
        { companion: params[:companion] }
      )
    end

    def save_precheckin_record
      @precheckin_exists = false
      
      if precheckin = find_existing_precheckin
        @precheckin_exists = true
        precheckin.update!(params)
      else
        ReservationPrecheckin.create!(
          params.merge(
            line_friend_id: friend.id,
            line_account_id: friend.line_account_id
          )
        )
      end
    end

    def reservation_exists?
      find_reservation_in_pms.present?
    end

    def pms_api_key
      @pms_api_key ||= friend.line_account.pms_api_key
    end

    def valid?
      if params[:phone_number].blank?
        @errors << 'Phone number is required'
      end

      if params[:check_in_date].blank?
        @errors << 'Check-in date is required'
      end

      @errors.empty?
    end
  end
end