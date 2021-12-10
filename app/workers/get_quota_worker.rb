# frozen_string_literal: true

class GetQuotaWorker
  include Sidekiq::Worker

  def perform(*args)
    LineAccount.all.each do |line_account|
      next if line_account.channel_id.nil?
      insight = Insight.find_or_initialize_by(line_account: line_account, type: :monthly, date: Time.zone.today.beginning_of_month)
      quota = LineApi::GetQuota.new(line_account).perform
      insight.quota = quota
      insight.save!
    end
  end
end
