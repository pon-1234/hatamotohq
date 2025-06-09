# frozen_string_literal: true

class Subdomain::AdminConstraint
  def matches?(request)
    if Rails.env.production?
      request.subdomain.present? && request.subdomain.include?('admin')
    else
      request.subdomain.blank?
    end
  end

  def self.path
    'admin'
  end
end
