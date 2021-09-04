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
      nomalized_messages_data << normalize_message_content(message.content)
    end

    # Deliver messages via line api
    if !send_broadcast(line_account, nomalized_messages_data)
      broadcast.update_status('error')
      return
    end
    nomalized_messages_data.each do |content|
      insert_delivered_message(line_account, content)
    end
  end

  # send message to specific friend
  # using multicast api to send message to friends
  def dispatch_with_condition(broadcast)
    line_account = broadcast.line_account

    friends = filter_friend_by_conditions(broadcast)
    messages = broadcast.broadcast_messages

    nomalized_messages_data = []
    messages.each do |message|
      nomalized_messages_data << normalize_message_content(message.content)
    end
    if !send_multicast(line_account, nomalized_messages_data, friends.map(&:line_user_id))
      broadcast.update_status('error')
    end
  end

  private
    def send_broadcast(line_account, messages_data)
      LineApi::PostMessageBroadcast.new(line_account.line_channel_id, line_account.line_channel_secret, messages_data).perform
    end

    def send_multicast(line_account, messages_data, friend_ids)
      friend_ids.in_groups_of(400, false) do |ids|
        LineApi::PostMessageMulticast.new(line_account.line_channel_id, line_account.line_channel_secret, messages_data, ids).perform
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
        friends.where(tags: { id: broadcast.tag_ids })
      end
      friends
    end

    def normalize_message_content(message_content)
      message_type = message_content['type']
      return message_content if message_type != 'text'

      if message_type == 'flex' && message_content['id'].present?
        message_content = normalize_flex_message_content(message_content)
      end

      message_content = handle_postback(message_content)
      message_content = handle_media(message_content)

      # if ($messageContent['type'] === 'flex' && $message['id']) {
      #   $flexMessage = FlexMessage::query()->where('id', $messageContent['id'])->first();
      #   if ($flexMessage) {
      #     $flexMessageSended = FlexMessageSendedLog::query()->create([
      #       'flex_message_id' => $flexMessage->id,
      #       'line_account_id' => $lineAccount->id,
      #       'html_template' => $flexMessage->html_template,
      #     ]);
      #     $messageContent['id'] = $flexMessageSended->id;
      #   }
      # }
    end

    def normalize_flex_message_content(message_content)
      flex_message_id = message_content['id']
      flex_message = FlexMessage.find(flex_message_id)
      if flex_message.present?
        message_content = JSON.parse(flex_message.json_message)
        message_content['id'] = flex_message_id
      end
    end

    def handle_postback(message_content)
      #     $messageContent = collect($messageContent)->recursive(function ($o) {
      #     if (isset($o['label'])) {
      #         $o['label'] = empty($o['label']) ? NULL : $o['label'];
      #     }
      #   if (isset($o['type'])) {
      #     if (($o['type'] === 'postback' || $o['type'] == 'datetimepicker')) {
      #       $val = json_decode(base64_decode($o['data']), true);
      #       // lấy data
      #         if ($o['type'] === 'postback') {
      #             $val['displayText'] = $o['displayText'] = empty($o['displayText']) ? NULL : $o['displayText'];
      #         }

      #       $o['data'] = base64_encode(json_encode($val));
      #       $hash = md5($o['data'] );
      #       // checksum
      #       PostbackChecksum::query()->firstOrCreate([
      #         'hash' => $hash,
      #       ], [
      #         'hash' => $hash,
      #         'data' => $o['data'],
      #       ]);

      #       $o['data'] = $hash;
      #     } elseif ($o['type'] === 'survey') {
      #       $content = $o['content'];
      #       $o['type'] = 'uri';
      #       $o['uri'] = env('APP_FLEXA_URL').'/surveys/liff?code='.$content['code'];
      #       unset($o['data']);
      #       unset($o['content']);
      #     }
      #   }
      #   return $o;
      # })->toArray();
      message_content
    end

    def handle_media(message_content)
      message_content
      # if (in_array($messageContent['type'], ["image", "video"])) {
      #   $messageContent["contentProvider"] = [
      #     "type" => "external",
      #     "originalContentUrl" => $messageContent["originalContentUrl"],
      #     "previewImageUrl" => $messageContent["previewImageUrl"]
      #   ];
      # }

      # if (in_array($messageContent['type'], ["audio"])) {
      #   $messageContent["contentProvider"] = [
      #     "type" => "external",
      #     "originalContentUrl" => $messageContent["originalContentUrl"],
      #     "duration" => $messageContent["duration"]
      #   ];
      # }
    end

    def insert_delivered_message(line_account, message_content)
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
