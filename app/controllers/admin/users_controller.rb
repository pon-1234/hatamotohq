# frozen_string_literal: true

class Admin::UsersController < Admin::ApplicationController
  before_action :find_user, only: [:show]

  # GET /admin/users
  def index
  end

  # GET /admin/users/new
  def new
  end

  def show
  end

  # POST /admin/users
  def create
    # TODO
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_user_path(@user), flash: { success: 'success' }
    else
      redirect_to admin_users_path, flash: { error: 'errors' }
    end
  end

  private
    def user_params
      params.require(:user)
      .permit(
        :email,
        :name,
        :password,
        :password_confirmation
      )
    end

    def find_user
      @user = User.find(params[:id])
    end
end
