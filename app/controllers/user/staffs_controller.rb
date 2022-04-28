# frozen_string_literal: true

class User::StaffsController < User::ApplicationController
  before_action :find_staff, only: [:show, :edit, :update, :destroy, :delete_confirm, :sso]

  # GET /user/staffs
  def index
    if request.format.json?
      @params = params[:q]
      @q = Current.user.client.users.staff.ransack(@params)
      @staffs = @q.result.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /user/staffs/all
  def all
    @staffs = Current.user.client.users.staff.active
  end

  # GET /user/staffs/new
  def new
  end

  # POST /user/staffs
  def create
    @staff = User.new(user_params)
    @staff.client = Current.user.client
    @staff.role = :staff
    @staff.save!
  rescue => e
    render_bad_request_with_message(e.message)
  end

  # GET /user/staffs/:id/edit
  def edit
  end

  # PATCH /user/staffs/:id
  def update
    success = @staff.update_with_password(user_params.merge(current_password: params[:current_password]))
    raise @staff.errors.full_messages.first unless success
  rescue => e
    render_bad_request_with_message(e.message)
  end

  # DELETE /user/staffs/:id
  def destroy
    @staff.destroy!
    render_success
  end

  # GET /user/staffs/:id/sso
  def sso
    if @staff.active?
      sign_in @staff
      redirect_to user_root_path
    else
      redirect_to admin_users_path, flash: { warning: 'スタッフはブロック中ですので、ログインできませんでした。' }
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

    def find_staff
      @staff = User.find(params[:id])
    end
end
