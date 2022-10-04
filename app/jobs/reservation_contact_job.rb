# frozen_string_literal: true

class ReservationContactJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :default

  def perform(guest_info)
    ReservationContact::ContactWithFriendInformation.new.perform guest_info
  end
end
