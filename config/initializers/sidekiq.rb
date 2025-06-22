# frozen_string_literal: true

# Sidekiq::Extensions.enable_delay! is deprecated and removed in Sidekiq 7+

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end
