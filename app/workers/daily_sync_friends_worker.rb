# frozen_string_literal: true

class DailySyncFriendsWorker
  include Sidekiq::Worker

  def perform(*args)
    LineAccount.all.each do |line_account|
      SyncLineFriendsJob.perform_later(line_account.id)
    end
  end
end
