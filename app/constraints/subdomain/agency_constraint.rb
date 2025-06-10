# frozen_string_literal: true

class Subdomain::AgencyConstraint
  def matches?(request)
    if Rails.env.production?
      subdomain = request.subdomain.to_s
      Rails.logger.info "AgencyConstraint: host=#{request.host}, subdomain='#{subdomain}'"
      subdomain.present? && subdomain.include?('agency')
    else
      request.subdomain.blank?
    end
  end

  def self.path
    'agency'
  end
end
