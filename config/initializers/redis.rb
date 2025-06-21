# frozen_string_literal: true

require 'redis'

# Configure Redis connection
redis_url = ENV.fetch('REDIS_URL', 'redis://localhost:6379/1')

# Create a Redis connection pool for the application
$redis = Redis.new(url: redis_url)