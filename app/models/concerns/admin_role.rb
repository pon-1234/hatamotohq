# frozen_string_literal: true

module AdminRole
  extend ActiveSupport::Concern

  included do
    enum role: {
      superadmin: 'superadmin',
      admin: 'admin'
    }
  end
end
