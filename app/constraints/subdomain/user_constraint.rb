# frozen_string_literal: true

class Subdomain::UserConstraint
  def matches?(request)
    if Rails.env.production?
      # Allow main domain (no subdomain) or valid client subdomains
      (request.subdomain.blank? || (request.subdomain.present? && !request.subdomain.include?('admin') && !request.subdomain.include?('agency')))
    else
      request.subdomain.blank?
    end
  end

  def self.path
    'user'
  end
end
