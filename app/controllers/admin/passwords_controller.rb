# frozen_string_literal: true

class Admin::PasswordsController < Devise::PasswordsController
  layout 'auth'

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    admin = Admin.reset_password_by_token(params)
    if admin.reset_password_period_valid?
      super
    else
      redirect_to new_admin_password_expired_path
    end
  end

  def sent
  end

  def expired
  end

  protected
    def after_resetting_password_path_for(resource)
      admin_root_path
    end

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      new_admin_password_sent_path if is_navigational_format?
    end
end
