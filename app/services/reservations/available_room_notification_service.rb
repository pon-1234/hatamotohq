# frozen_string_literal: true

module Reservations
  class AvailableRoomNotificationService
    attr_reader :room_params, :notifier_id, :errors

    def initialize(room_params, notifier_id)
      @room_params = room_params
      @notifier_id = notifier_id
      @errors = []
    end

    def process
      return false unless valid?

      available_stock = calculate_minimum_stock
      reservation = find_reservation

      unless reservation && reservation.stock <= available_stock
        @errors << 'Could not find the data or the stock is less than expected'
        return false
      end

      AvailableRoomNotificationJob.perform_later(formatted_params, reservation)
      true
    rescue StandardError => e
      @errors << e.message
      false
    end

    private

    def valid?
      validator = SendAvailableRoomNotificationValidator.new(
        type_id: room_params['id'],
        notifier_id: notifier_id
      )

      unless validator.valid?
        @errors.concat(validator.errors.full_messages)
        return false
      end

      true
    end

    def calculate_minimum_stock
      stock_calendar = room_params[:stockCalendar] || []
      return 0 if stock_calendar.empty?

      stock_calendar.pluck(:stock).compact.min || 0
    end

    def find_reservation
      Reservation.wait.find_by(
        room_id: room_params[:id],
        notifier_id: notifier_id
      )
    end

    def formatted_params
      @formatted_params ||= begin
        params = room_params.dup
        params.deep_transform_keys! { |key| key.to_s.camelize(:lower) }
        params
      end
    end
  end
end