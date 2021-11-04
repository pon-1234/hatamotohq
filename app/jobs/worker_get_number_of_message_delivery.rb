# frozen_string_literal: true

class WorkerGetNumberOfMessageDelivery
  include Sidekiq::Worker

  def perform(*args)
    LineAccount.active.each do |line_account|
      response = LineApi::GetNumberOfMessageDeliveries.new(line_account).perform(Time.zone.today)
      next unless response.code == '200'
      data = response.body
      insight = Insight.find_or_initialize_by(line_account: line_account, type: :daily, date: Time.zone.today)
      insight.broadcast = data.try(:broadcast)
      insight.targeting = data.try(:targeting)
      insight.auto_response = data.try(:auto_response)
      insight.welcome_response = data.try(:welcome_response)
      insight.chat = data.try(:chat)
      insight.api_broadcast = data.try(:api_broadcast)
      insight.api_push = data.try(:api_push)
      insight.api_multicast = data.try(:api_multicast)
      insight.api_narrowcast = data.try(:api_narrowcast)
      insight.api_reply = data.try(:api_reply)
      insight.save!
    end
  end
end
