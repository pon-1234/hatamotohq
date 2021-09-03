# frozen_string_literal: true

class AutoResponseJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    message_text = message.text

    auto_response_ids = AutoResponseKeyword
      .select('auto_responses.id')
      .joins(:auto_response)
      .references(:auto_response)
      .where(auto_responses: { line_account_id: message.channel.line_account_id })
      .where("? LIKE  CONCAT('%', auto_response_keywords.keyword ,'%')", message_text)
      .uniq
    return if auto_response_ids.blank?

    # # Send auto response message if keyword is hitted
    message_content = []
    auto_response_ids.each do |auto_response_id|
      auto_response_messages = AutoResponse.where(id: auto_response_id, status: 'enable').first&.auto_response_messages
      next if auto_response_messages.blank?

      auto_response_messages.each do |reply_message|
        message_content << {
          message: reply_message.content
        }
      end
    end
    return if message_content.blank?
    # # Rebuild payload
    payload = {
      channel_id: message.channel_id,
      line_account_id: message.channel.line_account_id,
      line_friend_id: message.sender.id,
      reply_token: message.reply_token,
      messages: message_content
    }
    PushMessageToLineJob.perform_later(payload)
  end
end
