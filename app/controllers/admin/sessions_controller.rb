# frozen_string_literal: true

class Admin::SessionsController < Devise::SessionsController
  layout 'auth'

  protected
    def after_sign_in_path_for(admin)
      admin.superadmin? ? admin_accounts_path : admin_agencies_path
    end

    def after_sign_out_path_for(admin)
      new_admin_session_path
    end
end
