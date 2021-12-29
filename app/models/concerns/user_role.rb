# frozen_string_literal: true

module UserRole
  extend ActiveSupport::Concern

  included do
    enum role: {
      admin: 'admin',
      staff: 'staff'
    }
  end
end
