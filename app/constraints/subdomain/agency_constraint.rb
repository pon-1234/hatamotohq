# frozen_string_literal: true

class Subdomain::AgencyConstraint
  def matches?(request)
    if Rails.env.production?
      request.subdomain.present? && request.subdomain.include?('agency')
    else
      request.subdomain.blank?
    end
  end

  def self.path
    'agency'
  end
end
