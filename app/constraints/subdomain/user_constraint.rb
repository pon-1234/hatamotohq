# frozen_string_literal: true

class Subdomain::UserConstraint
  def matches?(request)
    if Rails.env.production?
      # In production, be more permissive - allow all requests that aren't specifically admin or agency
      subdomain = request.subdomain.to_s
      # Log for debugging
      Rails.logger.info "UserConstraint: host=#{request.host}, subdomain='#{subdomain}'"
      
      # Allow if no subdomain or subdomain doesn't contain admin/agency
      !subdomain.include?('admin') && !subdomain.include?('agency')
    else
      request.subdomain.blank?
    end
  end

  def self.path
    'user'
  end
end
