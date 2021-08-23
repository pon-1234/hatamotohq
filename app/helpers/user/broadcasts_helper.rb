module User::BroadcastsHelper
  def build_broadcast(broadcast_params)
    conditions = broadcast_params[:conditions]
    type = broadcast_params[:type] || 'all'
    if type.eql?('all')
      conditions = Broadcast::CONDITION_SEND_ALL
    end

    broadcast = Broadcast.new
    broadcast.line_account = current_user.line_account
    broadcast.title = broadcast_params[:title]
    broadcast.conditions = conditions
    broadcast.type = broadcast_params[:type]
    broadcast.date_start = broadcast_params[:date_start]
    broadcast.deliver_now = broadcast_params[:date_start]
    broadcast.status = :pending
    # Attach tags
    broadcast.tag_ids = broadcast_params[:tag_ids]
    broadcast
  end

  def build_broadcast_messages(broadcast, broadcast_messages_params)
    # Delete old messages before adding new one
    broadcast.broadcast_messages.destroy_all
    # Insert new message
    broadcast_messages_params.each do |broadcast_message_params|
      broadcast_message = BroadcastMessage.new(broadcast_message_params)
      broadcast_message.broadcast = broadcast
      broadcast_message.save!
    end
  end
end
