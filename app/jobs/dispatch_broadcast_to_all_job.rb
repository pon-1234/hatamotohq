# frozen_string_literal: true

class DispatchBroadcastToAllJob < ApplicationJob
  queue_as :default

  def perform(broadcast)
    line_account = LineAccount.find(broadcast.line_account_id)
    return unless line_account.status_active?

    friends = line_account.line_friends
    messages = broadcast.broadcast_messages
    channels = Channel.where(line_friend_id: friends.map(&:id))

    message_contents = []
    messages.each do |message|
      message_contents << normalize_message_content(message.content)
    end

    # Deliver messages via line api
    if !deliver_messages(line_account, message_contents)
      broadcast.status = :error
      broadcast.save
      return
    end
    message_contents.each do |content|
      insert_delivered_message(line_account, content)
    end

    # Set broadcast's status to done
    broadcast.status = :done
    broadcast.save
  end

  def deliver_messages(line_account, messages)
    LineApi::PostMessageBroadcast.new(line_account.line_channel_id, line_account.line_channel_secret, messages).perform
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
    #       'line_timestamp' => $now.'000',
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
    #       'line_timestamp' => $now.'000',
    #       'line_reply_token' => '',
    #       'raw_content' => json_encode($body),
    #     ];
    #     $this->_saveMessage($savedDate, $channel, false);
  end
end
