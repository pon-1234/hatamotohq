class DispatchBroadcastJob < ApplicationJob
  queue_as :default

  def perform(broadcast_id)
    broadcast = Broadcast.find(broadcast_id)
    # Change broadcast status to sending
    broadcast.status = :sending
    broadcast.save

    messages = broadcast.broadcast_messages
    # if broadcast.type == :all
      DispatchBroadcastToAllJob.perform_later(broadcast)
    # end
  end
end
