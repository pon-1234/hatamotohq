# frozen_string_literal: true

class MessageNormalizer
  def initialize(message_content)
    @message_content = message_content
  end

  def perform
    message_type = @message_content['type']

    if message_type == 'flex' && @message_content['id'].present?
      normalize_flex_message
    end
    normalize_postback

    # Return normalized content
    @message_content
  end

  def normalize_flex_message
    flex_message_id = @message_content['id']
    flex_message = FlexMessage.find(flex_message_id)
    if flex_message.present?
      @message_content = JSON.parse(flex_message.json_message)
      @message_content['id'] = flex_message_id
    end
    # TODO
  end

  def normalize_postback
    @message_content.extend Hashie::Extensions::DeepLocate
    # Find all postback action
    actions = @message_content.deep_locate -> (key, value, object) { key.eql?('type') && value.eql?('postback') }
    actions.each do |action|
      # Line API limit postback data's length to 300 character
      # we have to cache the postback data in database and restore it
      # when receiving postback event
      hash = Digest::MD5.hexdigest action['data'].to_json
      PostbackMapper.create(key: hash, value: action['data'])
      action['data'] = hash
    end
  end

  def handle_media
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
end
