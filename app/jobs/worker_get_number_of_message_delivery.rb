# frozen_string_literal: true

class WorkerGetNumberOfMessageDelivery
  include Sidekiq::Worker

  def perform(*args)
    LineAccount.active.each do |line_account|
      ActiveJob::Base.logger.info "Start WorkerGetNumberOfMessageDelivery Account ID = #{line_account.id}"
      next if line_account.channel_id.nil?
      response = LineApi::GetNumberOfMessageDeliveries.new(line_account).perform(Time.zone.yesterday)
      next unless response.code == '200'
      data = JSON.parse(response.body)
      ActiveJob::Base.logger.info "Response WorkerGetNumberOfMessageDelivery #{data}"
      insight = Insight.find_or_initialize_by(line_account: line_account, type: :daily, date: Time.zone.yesterday)
      insight.broadcast = data["broadcast"]
      insight.targeting = data["targeting"]
      insight.auto_response = data["autoResponse"]
      insight.welcome_response = data["welcomeResponse"]
      insight.chat = data["chat"]
      insight.api_broadcast = data["apiBroadcast"]
      insight.api_push = data["apiPush"]
      insight.api_multicast = data["apiMulticast"]
      insight.api_narrowcast = data["apiNarrowcast"]
      insight.api_reply = data["apiReply"]
      insight.save!
      ActiveJob::Base.logger.info "End WorkerGetNumberOfMessageDelivery Account ID = #{line_account.id}"
    end
  end
end
