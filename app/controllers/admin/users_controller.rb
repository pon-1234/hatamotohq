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
      redirect_to admin_user_path(@user), flash: { success: 'create success' }
    else
      redirect_to admin_users_path, flash: { error: 'create errors' }
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
        format.html { redirect_to edit_admin_user_path(@user), flash: { error: 'update error' } }
        format.json { render json: { message: 'errors', errors: @user.errors }, status: 400 }
      end
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, flash: { success: 'destroy success' }
    else
      redirect_to admin_users_path, flash: { error: 'destroy error' }
    end
  end

  def delete_confirm
    respond_to do |format|
      format.js
    end
  end

  def validate_unique
    if params[:user_id].present?
      user = User.find_by(email: params[:email])
      unique = !user.present? || user.id === params[:user_id]
    else
      unique = !User.exists?(email: params[:email])
    end
    render json: { unique: unique }
  end

  private
    def user_params
      params.require(:user)
      .permit(
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
