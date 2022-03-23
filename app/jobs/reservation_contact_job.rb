# frozen_string_literal: true

class ReservationContactJob < ApplicationJob
  sidekiq_options retry: false
  queue_as :default

  def perform(friend_search_information, friend_line_id)
    ReservationContact::ContactWithFriendInformation.new.perform friend_search_information, friend_line_id
  end
end
