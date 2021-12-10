# frozen_string_literal: true

class GetNumberOfMessageDeliveryWorker
  include Sidekiq::Worker

  def perform(*args)
    LineAccount.all.each do |line_account|
      next if line_account.channel_id.nil?
      response = LineApi::GetNumberOfMessageDeliveries.new(line_account).perform(Time.zone.yesterday)
      next unless response.code == '200'
      data = JSON.parse(response.body)
      insight = Insight.find_or_initialize_by(line_account: line_account, type: :daily, date: Time.zone.yesterday)
      insight.broadcast = data['broadcast']
      insight.targeting = data['targeting']
      insight.auto_response = data['autoResponse']
      insight.welcome_response = data['welcomeResponse']
      insight.chat = data['chat']
      insight.api_broadcast = data['apiBroadcast']
      insight.api_push = data['apiPush']
      insight.api_multicast = data['apiMulticast']
      insight.api_narrowcast = data['apiNarrowcast']
      insight.api_reply = data['apiReply']
      insight.save!
    end
  end
end
