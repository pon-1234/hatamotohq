# frozen_string_literal: true

class Admin::UsersController < Admin::ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy, :delete_confirm]

  # GET /admin/users
  def index
    @params = params[:q]
    @q = User.ransack(@params)
    @users = @q.result.page(params[:page])
  end

  def search
    index
    render :index
  end

  # POST /admin/users
  def create
    # TODO
    @user = User.new(user_params)
    if @user.save
      respond_to do |format|
        format.html { redirect_to admin_user_path(@user), flash: { success: 'create success' } }
        format.json { render json: @user }
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_users_path, flash: { error: @user.first_error_message } }
        format.json { render json: { message: 'errors', errors: @user.first_error_message }, status: 400 }
      end
    end
  end

  def update
    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to admin_user_path(@user), flash: { success: 'update success' } }
        format.json { render json: @user }
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_admin_user_path(@user), flash: { error: @user.first_error_message } }
        format.json { render json: { message: 'errors', errors: @user.first_error_message }, status: 400 }
      end
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, flash: { success: 'destroy success' }
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
