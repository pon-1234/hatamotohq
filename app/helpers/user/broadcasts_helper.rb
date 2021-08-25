# frozen_string_literal: true

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
    broadcast.schedule_at = broadcast_params[:schedule_at]
    broadcast.deliver_now = broadcast_params[:deliver_now]
    broadcast.status = broadcast_params[:status]
    # Attach tags
    broadcast.tag_ids = broadcast_params[:tag_ids]
    broadcast
  end

  def update_broadcast(broadcast, broadcast_params)
    conditions = broadcast_params[:conditions]
    type = broadcast_params[:type] || 'all'
    if type.eql?('all')
      conditions = Broadcast::CONDITION_SEND_ALL
    end

    broadcast.title = broadcast_params[:title]
    broadcast.conditions = conditions
    broadcast.type = broadcast_params[:type]
    broadcast.schedule_at = broadcast_params[:schedule_at]
    broadcast.deliver_now = broadcast_params[:deliver_now]
    broadcast.status = broadcast_params[:status]
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

  def render_broadcast_status(status)
    case status
    when 'pending'
      '<span class="badge badge-primary p-2">配信予約</span>'
    when 'sending'
      '<span class="badge badge-info p-2">配信中</span>'
    when 'done'
      '<span class="badge badge-success p-2">配信済</span>'
    when 'error'
      '<span class="badge badge-danger p-2">エラー</span>'
    when 'draft'
      '<span class="badge badge-secondary p-2">下書き</span>'
    end
  end
end
