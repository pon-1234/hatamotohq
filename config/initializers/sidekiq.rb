# frozen_string_literal: true

Sidekiq::Extensions.enable_delay!

Sidekiq.logger = Logger.new("#{Rails.root}/log/worker.log")
Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'lineinsight' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'], namespace: 'lineinsight' }
end
