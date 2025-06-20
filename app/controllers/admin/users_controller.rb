# frozen_string_literal: true

class Admin::UsersController < Admin::ApplicationController
  before_action :find_user, only: [:update, :destroy, :sso]

  # GET /admin/users
  def index
    if request.format.json?
      @params = params[:q]
      @q = User.ransack(@params)
      @users = @q.result.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # POST /admin/users
  def create
    @user = User.new(user_params)
    if !@user.save
      render_bad_request_with_message(@user.first_error_message)
    end
  end

  # PATCH /admin/users/:id
  def update
    if !@user.update(user_params)
      render_bad_request_with_message(@user.first_error_message)
    end
  end

  # DELETE /admin/users/:id
  def destroy
    @user.destroy!
    render_success
  end

  # GET /admin/users/:id/sso
  def sso
    if @user.active?
      sign_in @user
      redirect_to user_root_path
    else
      redirect_to admin_users_path, flash: { warning: 'ユーザーはブロック中ですので、ログインできませんでした。' }
    end
  end

  private
    def user_params
      params.permit(
        :email,
        :name,
        :status,
        :company_name,
        :phone_number,
        :address,
        :password,
        :password_confirmation
      )
    end

    def find_user
      @user = User.find(params[:id])
    end
end
