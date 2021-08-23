class DispatchBroadcastJob < ApplicationJob
  queue_as :default

  def perform(broadcast_id)
    broadcast = Broadcast.find(broadcast_id)
    # Change broadcast status to sending
    broadcast.deliver_at = Time.zone.now
    broadcast.status = :sending
    broadcast.save

    messages = broadcast.broadcast_messages
    # if broadcast.type == :all
      DispatchBroadcastToAllJob.perform_now(broadcast)
    # end
  end
end
