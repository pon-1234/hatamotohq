# frozen_string_literal: true

class User::SessionsController <  Devise::SessionsController
  layout 'auth'

  protected
    def after_sign_in_path_for(user)
      user.admin? ? user_home_path : user_channels_path
    end
end
