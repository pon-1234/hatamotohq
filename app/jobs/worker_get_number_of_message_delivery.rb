# frozen_string_literal: true

class WorkerGetNumberOfMessageDelivery
  include Sidekiq::Worker

  def perform(*args)
    LineAccount.active.each do |line_account|
      next if line_account.channel_id.nil?
      response = LineApi::GetNumberOfMessageDeliveries.new(line_account).perform(Time.zone.today)
      next unless response.code == '200'
      data = response.body
      insight = Insight.find_or_initialize_by(line_account: line_account, type: :daily, date: Time.zone.today)
      insight.broadcast = data.try(:broadcast)
      insight.targeting = data.try(:targeting)
      insight.auto_response = data.try(:autoResponse)
      insight.welcome_response = data.try(:welcomeResponse)
      insight.chat = data.try(:chat)
      insight.api_broadcast = data.try(:apiBroadcast)
      insight.api_push = data.try(:apiPush)
      insight.api_multicast = data.try(:apiMulticast)
      insight.api_narrowcast = data.try(:apiNarrowcast)
      insight.api_reply = data.try(:apiReply)
      insight.save!
    end
  end
end
