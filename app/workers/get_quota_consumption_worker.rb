# frozen_string_literal: true

class GetQuotaConsumptionWorker
  include Sidekiq::Worker

  def perform(*args)
    LineAccount.all.each do |line_account|
      next if line_account.channel_id.nil?
      insight = Insight.find_or_initialize_by(line_account: line_account, type: :monthly, date: Time.zone.today.beginning_of_month)
      total_usage = LineApi::GetQuotaConsumption.new(line_account).perform
      insight.total_usage = total_usage
      insight.save!
    end
  end
end
