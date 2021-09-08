# frozen_string_literal: true

class AutoResponseJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    message = Message.find(message_id)
    auto_response_ids = hit_auto_responses(message)
    return if auto_response_ids.blank?

    # Send auto response message if keyword is hit
    auto_responses = AutoResponse.where(id: auto_response_ids, status: 'enable')
    reply_messages = []
    auto_responses.each do |auto_response|
      reply_messages << auto_response.auto_response_messages.pluck(:content)
    end

    # Rebuild payload
    payload = {
      channel_id: message.channel_id,
      reply_token: message.reply_token,
      messages: reply_messages
    }
    PushMessageToLineJob.perform_later(payload)
  end

  private
    def hit_auto_responses(message)
      AutoResponseKeyword
        .select('auto_responses.id')
        .joins(:auto_response)
        .references(:auto_response)
        .where(auto_responses: { line_account_id: message.channel.line_account_id })
        .where("? LIKE  CONCAT('%', auto_response_keywords.keyword ,'%')", message.text)
        .uniq
    end
end
