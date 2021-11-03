# frozen_string_literal: true

class WorkerInsightAnalyzer
  include Sidekiq::Worker

  def perform(*args)
    LineAccount.all.each do |line_account|
      response = LineApi::GetNumberOfMessageDeliveries.new(line_account).perform(Time.zone.today)
      insight = Insight.find_or_initialize_by(line_account: line_account, type: :daily, date: Time.zone.today)
      insight.broadcast = response.broadcast
      insight.targeting = response.targeting
      insight.auto_response = response.auto_response
      insight.welcome_response = response.welcome_response
      insight.chat = response.chat
      insight.api_broadcast = response.api_broadcast
      insight.api_push = response.api_push
      insight.api_multicast = response.api_multicast
      insight.api_narrowcast = response.api_narrowcast
      insight.api_reply = response.api_reply
      insight.save!
    end
  end
end
