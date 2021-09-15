# frozen_string_literal: true

class SendTemplateJob < ApplicationJob
  queue_as :default

  def perform(channel_id, template_id)
    template = Template.find(template_id)
    template_messages = template.template_messages
    messages = template_messages.map(&:content)
    payload = {
      channel_id: channel_id,
      messages: messages
    }
    PushMessageToLineJob.perform_now(payload)
  end
end
