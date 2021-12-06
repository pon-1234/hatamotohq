# frozen_string_literal: true

class Normalizer::MessageNormalizer
  def initialize(message_content)
    @message_content = message_content
  end

  def perform
    return if @message_content.nil?
    message_type = @message_content['type']
    if message_type == 'flex' && @message_content['id'].present?
      normalize_flex_message
    end

    Normalizer::PostbackNormalizer.new(@message_content).perform

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
end
