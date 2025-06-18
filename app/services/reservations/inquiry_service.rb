# frozen_string_literal: true

module Reservations
  class InquiryService
    attr_reader :params, :errors

    def initialize(params)
      @params = params
      @errors = []
    end

    def process
      return false unless valid?

      ReservationInquiryJob.perform_later(params)
      true
    rescue StandardError => e
      @errors << e.message
      false
    end

    private

    def valid?
      if params[:friend_line_id].blank?
        @errors << 'Friend LINE ID is required'
      end

      if params[:num_room].blank? || params[:num_room].to_i <= 0
        @errors << 'Number of rooms must be greater than 0'
      end

      if params[:date_start].blank?
        @errors << 'Start date is required'
      end

      if params[:date_end].blank?
        @errors << 'End date is required'
      end

      if params[:date_start].present? && params[:date_end].present?
        begin
          start_date = Date.parse(params[:date_start])
          end_date = Date.parse(params[:date_end])
          
          if start_date >= end_date
            @errors << 'End date must be after start date'
          end

          if start_date < Date.today
            @errors << 'Start date cannot be in the past'
          end
        rescue ArgumentError
          @errors << 'Invalid date format'
        end
      end

      @errors.empty?
    end
  end
end