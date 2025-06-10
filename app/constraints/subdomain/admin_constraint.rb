# frozen_string_literal: true

class Subdomain::AdminConstraint
  def matches?(request)
    if Rails.env.production?
      subdomain = request.subdomain.to_s
      Rails.logger.info "AdminConstraint: host=#{request.host}, subdomain='#{subdomain}'"
      subdomain.present? && subdomain.include?('admin')
    else
      request.subdomain.blank?
    end
  end

  def self.path
    'admin'
  end
end
