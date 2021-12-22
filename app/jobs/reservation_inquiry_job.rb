# frozen_string_literal: true

class ReservationInquiryJob < ApplicationJob
  queue_as :default

  def perform(params)
    name = params[:name]
    phone_number = params[:phone_number]
    date = params[:date]
  end
end
