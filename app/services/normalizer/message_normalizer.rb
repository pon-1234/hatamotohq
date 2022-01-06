# frozen_string_literal: true

class Normalizer::MessageNormalizer
  def initialize(message_content)
    @message_content = message_content
  end

  def perform
    return if @message_content.nil?
    Normalizer::PostbackNormalizer.new(@message_content).perform
    # Return normalized content
    @message_content
  end
end
