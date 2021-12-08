# frozen_string_literal: true

class User::SessionsController <  Devise::SessionsController
  layout 'auth'

  protected
    def after_sign_in_path_for(user)
      user.admin? ? admin_home_path : admin_friends_path
    end
end
