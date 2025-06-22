# frozen_string_literal: true

class Subdomain::AgencyConstraint
  def matches?(request)
    if Rails.env.production?
      subdomain = request.subdomain.to_s
      Rails.logger.info "AgencyConstraint: host=#{request.host}, subdomain='#{subdomain}'"
      
      # Special handling for Fly.io domains
      if request.host.include?('.fly.dev')
        parts = request.host.split('.')
        if parts.size > 3
          # This has actual subdomains like agency.appname.fly.dev
          actual_subdomain = parts.first
          return actual_subdomain.include?('agency')
        else
          # No real subdomain for agency
          return false
        end
      else
        subdomain.present? && subdomain.include?('agency')
      end
    else
      request.subdomain.blank?
    end
  end

  def self.path
    'agency'
  end
end
