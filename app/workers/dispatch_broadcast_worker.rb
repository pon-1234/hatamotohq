# frozen_string_literal: true

class DispatchBroadcastWorker
  include Sidekiq::Worker

  def perform(*args)
    broadcasts = Broadcast.dispatchable
    broadcasts.each do |broadcast|
      DispatchBroadcastJob.perform_later(broadcast.id)
    end
  end
end
