class HealthController < ApplicationController
  # Skip authentication for health checks
  skip_before_action :verify_authenticity_token

  def index
    render json: { 
      status: 'ok', 
      timestamp: Time.current.iso8601,
      version: Rails.version
    }, status: :ok
  end
end 