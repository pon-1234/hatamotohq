# frozen_string_literal: true

class Subdomain::UserConstraint
  def matches?(request)
    if Rails.env.production?
      # In production, be more permissive - allow all requests that aren't specifically admin or agency
      subdomain = request.subdomain.to_s
      # Log for debugging
      Rails.logger.info "UserConstraint: host=#{request.host}, subdomain='#{subdomain}'"
      
      # Special handling for Fly.io domains
      if request.host.include?('.fly.dev')
        # For fly.dev domains, ignore the app name as subdomain
        # e.g., hatamotohq.fly.dev should be treated as no subdomain
        # but admin.hatamotohq.fly.dev should be treated as admin subdomain
        parts = request.host.split('.')
        if parts.size == 3 && parts[1] == 'fly' && parts[2] == 'dev'
          # This is just appname.fly.dev, treat as no subdomain
          return true
        elsif parts.size > 3
          # This has actual subdomains like admin.appname.fly.dev
          actual_subdomain = parts.first
          return !actual_subdomain.include?('admin') && !actual_subdomain.include?('agency')
        end
      else
        # Allow if no subdomain or subdomain doesn't contain admin/agency
        !subdomain.include?('admin') && !subdomain.include?('agency')
      end
    else
      request.subdomain.blank?
    end
  end

  def self.path
    'user'
  end
end
