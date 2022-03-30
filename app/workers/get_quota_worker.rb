# frozen_string_literal: true

class GetQuotaWorker
  include Sidekiq::Worker

  def perform(*args)
    LineAccount.all.each do |line_account|
      next if line_account.channel_id.nil?
      line_account.get_messages_quota
    end
  end
end
