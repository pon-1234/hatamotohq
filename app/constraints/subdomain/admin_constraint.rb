# frozen_string_literal: true

class Subdomain::AdminConstraint
  def matches?(request)
    if Rails.env.production?
      subdomain = request.subdomain.to_s
      Rails.logger.info "AdminConstraint: host=#{request.host}, subdomain='#{subdomain}'"
      
      # Special handling for Fly.io domains
      if request.host.include?('.fly.dev')
        parts = request.host.split('.')
        if parts.size > 3
          # This has actual subdomains like admin.appname.fly.dev
          actual_subdomain = parts.first
          return actual_subdomain.include?('admin')
        else
          # No real subdomain for admin
          return false
        end
      else
        subdomain.present? && subdomain.include?('admin')
      end
    else
      request.subdomain.blank?
    end
  end

  def self.path
    'admin'
  end
end
