# frozen_string_literal: true

class User::SessionsController <  Devise::SessionsController
  layout 'auth'
end
