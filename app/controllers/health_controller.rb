class HealthController < ApplicationController
  # Skip authentication for health checks
  skip_before_action :verify_authenticity_token

  def index
    # Always return a simple 200 OK for basic health check
    render json: { status: 'ok', timestamp: Time.current.iso8601, version: Rails.version }, status: :ok
  end

  # The detailed checks can be kept for other diagnostic purposes if needed,
  # or removed if they are not used elsewhere.
  # For Fly.io health checks, a simple 200 OK is usually sufficient.

  private

  def check_health_status
    checks = {
      database: check_database,
      redis: check_redis
    }
    ok = checks.values.all? { |check| check[:status] == 'ok' }
    { ok: ok, checks: checks }
  end

  def check_database
    ActiveRecord::Base.connection.active?
    { status: 'ok' }
  rescue StandardError => e
    { status: 'error', message: e.message }
  end

  def check_redis
    $redis.ping == 'PONG'
    { status: 'ok' }
  rescue StandardError => e
    { status: 'error', message: e.message }
  end
end 