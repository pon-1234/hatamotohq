class HealthController < ApplicationController
  # Skip authentication for health checks
  skip_before_action :verify_authenticity_token

  def index
    health_status = check_health_status
    
    render json: { 
      status: health_status[:ok] ? 'ok' : 'error', 
      timestamp: Time.current.iso8601,
      version: Rails.version,
      checks: health_status[:checks]
    }, status: health_status[:ok] ? :ok : :service_unavailable
  end

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