# frozen_string_literal: true

class DispatchBroadcastJob < ApplicationJob
  queue_as :default

  def perform(broadcast_id)
    broadcast = Broadcast.find(broadcast_id)
    # Change broadcast status to sending
    broadcast.deliver_at = Time.zone.now
    broadcast.update_status('sending')

    dispatch_to_all(broadcast) if broadcast.broadcast_type_all?
    dispatch_with_condition(broadcast) if broadcast.broadcast_type_condition?
    broadcast.update_status('done')
  rescue => e
    p e.message
    broadcast&.update_status('error')
  end

  # send message to every friends of line official account
  # using broadcast api to reduce message count
  def dispatch_to_all(broadcast)
    line_account = broadcast.line_account
    friends = line_account.line_friends
    messages = broadcast.broadcast_messages
    channels = Channel.where(line_friend_id: friends.map(&:id))

    nomalized_messages_data = []
    messages.each do |message|
      nomalized_messages_data << Normalizer::MessageNormalizer.new(message.content).perform
    end

    # Deliver messages via line api
    if !send_broadcast(line_account, nomalized_messages_data)
      broadcast.update_status('error')
      return
    end
    nomalized_messages_data.each do |content|
      insert_delivered_message(channels, content)
    end
  end

  # send message to specific friend
  # using multicast api to send message to friends
  def dispatch_with_condition(broadcast)
    line_account = broadcast.line_account

    friends = filter_friend_by_conditions(broadcast)
    channels = Channel.where(line_friend_id: friends.map(&:id))
    messages = broadcast.broadcast_messages

    nomalized_messages_data = []
    messages.each do |message|
      nomalized_messages_data << Normalizer::MessageNormalizer.new(message.content).perform
    end
    if !send_multicast(line_account, nomalized_messages_data, friends.map(&:line_user_id))
      broadcast.update_status('error')
    end
    nomalized_messages_data.each do |content|
      insert_delivered_message(channels, content)
    end
  end

  private
    def send_broadcast(line_account, messages_data)
      LineApi::Broadcast.new(line_account).perform(messages_data)
    end

    def send_multicast(line_account, messages_data, friend_ids)
      friend_ids.in_groups_of(500, false) do |ids|
        LineApi::Multicast.new(line_account).perform(messages_data, ids)
      end
    end

    def filter_friend_by_conditions(broadcast)
      conditions = broadcast.conditions
      add_friend_date_cond = conditions['add_friend_date']
      friends = broadcast.line_account.line_friends
      if conditions['type']&.eql?('specific')
        friends = friends.created_at_gteq(add_friend_date_cond['start_date']).created_at_lteq(add_friend_date_cond['end_date'])
      end
      # filter by tags
      unless broadcast.tags.empty?
        friends = friends.joins(:tags).references(:tags).where(tags: { id: broadcast.tag_ids })
      end
      friends
    end

    def insert_delivered_message(channels, message_content)
      message_params = {
        message: message_content.with_indifferent_access,
        timestamp: Time.now.to_i
      }
      channels.each do |channel|
        Messages::MessageBuilder.new(nil, channel, message_params).perform
      end
      # slug = content['type'] == 'text' ? content['text'] : nil
      # $savedData = [
      #       'line_account_id' => $lineAccount->id,
      #       'line_customer_id' => $lineAccount->line_customer_id,
      #       'is_bot_sender' => TRUE,
      #       'attr' => 'chat-reverse',
      #       'line_message_id' => $now,
      #       'line_content' => json_encode($lineContent),
      #       'timestamp' => $now.'000',
      #       'line_reply_token' => '',
      #       'raw_content' => json_encode($body),
      #       'slug' => $slug,
      #     ];

      #     $this->_saveMessage($savedData, $channel);

      #     //create message log
      #     $savedLog = [
      #       'type' => 'log',
      #       'bot_sender' => config('const.LOG.VALUE.DISTRIBUTION'),
      #       'text' => config('const.LOG.TEXT.DISTRIBUTION').$body['title']
      #   ];
      #     $savedDate = [
      #       'line_account_id' => $lineAccount->id,
      #       'line_customer_id' => $lineAccount->line_customer_id,
      #       'is_bot_sender' => TRUE,
      #       'attr' => 'chat-log',
      #       'line_message_id' => $now,
      #       'line_content' => json_encode($savedLog),
      #       'timestamp' => $now.'000',
      #       'line_reply_token' => '',
      #       'raw_content' => json_encode($body),
      #     ];
      #     $this->_saveMessage($savedDate, $channel, false);
    end
end
