# frozen_string_literal: true

class Postback::SendTemplateHandler < Postback::BaseHandler
  def perform
    template_id = @content['template_id']
    SendTemplateJob.perform_now(@friend.channel.id, template_id)
  end
end
