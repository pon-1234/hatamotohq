# frozen_string_literal: true

class SystemMailer < ApplicationMailer
  default from: ENV.fetch('MAILER_SENDER', 'noreply@yopaz.vn')

  def postback_email(friend_id, payload)
    @friend = LineFriend.find(friend_id)
    receivers = payload['emails']
    @body = payload['text']
    bind_variables
    mail(to: receivers, subject: 'Hotel Insight CRMシステム')
  end

  def notify_assignee(admin, assignee, channel)
    @admin_name = admin.name || '管理者'
    @assignee_name = channel.line_friend.name
    routes = Rails.application.routes.url_helpers
    @channel_url = routes.user_channel_url(channel)
    receiver = assignee.email
    mail(to: receiver, subject: "#{@admin_name}さんが#{@assignee_name}さんの担当者をあなたに割り当てました。")
  end

  private
    def bind_variables
      @body = @body.gsub(/{name}/, @friend.name)
    end
end
