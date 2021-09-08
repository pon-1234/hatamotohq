# frozen_string_literal: true

class Admin::UsersController < Admin::ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy, :delete_confirm]

  # GET /admin/users
  def index
    @params = params[:q]
    @q = User.ransack(@params)
    @users = @q.result.page(params[:page])
  end

  # GET /admin/users/search
  def search
    index
    render :index
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
    if @user.destroy
      redirect_to admin_users_path, flash: { success: 'ユーザー削除は完了しました。' }
    else
      redirect_to admin_users_path, flash: { error: @user.first_error_message }
    end
  end

  def delete_confirm
    respond_to do |format|
      format.js
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
