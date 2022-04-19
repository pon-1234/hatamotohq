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
    broadcast.broadcast_messages.map(&:site_measurements).flatten.each(&:destroy)
    broadcast.broadcast_messages.destroy_all
    # Insert new message
    broadcast_messages_params.each do |broadcast_message_params|
      broadcast_message_params[:site_measurements_attributes].each do |site_measurement_attributes|
        site_measurement_attributes.delete(:id)
      end
      broadcast_message = BroadcastMessage.new(broadcast_message_params)
      broadcast_message.broadcast = broadcast
      broadcast_message.save!
    end
  end

  def render_broadcast_status(status)
    case status
    when 'pending'
      '<i class="mdi mdi-circle text-primary"></i> 配信予約'
    when 'sending'
      '<i class="mdi mdi-circle text-info"></i> 配信中'
    when 'done'
      '<i class="mdi mdi-circle text-success"></i> 配信済'
    when 'error'
      '<i class="mdi mdi-circle text-danger"></i> エラー'
    when 'draft'
      '<i class="mdi mdi-circle text-secondary"></i> 下書き'
    end
  end

  def render_broadcast_condition(broadcast)
    if broadcast.broadcast_type_all?
      '全て'
    else
      tags = broadcast.tags.map(&:name)
      html = ''
      tags.each do |tag|
        html = html + "<span class='tag m-1'>#{tag}</span>"
      end
      html
    end
  end
end
