# frozen_string_literal: true

class Subdomain::UserConstraint
  def matches?(request)
    # if Rails.env.production?
    #   request.subdomain.include?('user')
    # else
    #   request.subdomain.blank?
    # end
    true
  end

  def self.path
    'user'
  end
end
