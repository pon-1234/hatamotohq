# frozen_string_literal: true

class Subdomain::AgencyConstraint
  def matches?(request)
    # if Rails.env.production?
    #   request.subdomain.include?('admin')
    # else
    #   request.subdomain.blank?
    # end
    true
  end

  def self.path
    'agency'
  end
end
