# frozen_string_literal: true

class Admin::AccountsController < Admin::ApplicationController
  before_action :find_account, only: [:show, :edit, :update, :destroy]

  # GET /admin/accounts
  def index
    redirect_to admin_agencies_path unless current_admin.superadmin?
    if request.format.json?
      @q = Admin.ransack(params[:q])
      @accounts = @q.result.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # POST /admin/accounts
  def create
    authorize! :manage, Admin
    @account = Admin.new(account_params)
    @account.role = :admin
    @account.save!
    render_success
  rescue => e
    render_bad_request_with_message(e.message)
  end

  # PATCH /admin/accounts/:id
  def update
    authorize! :manage, Admin
    if @account.update(account_params)
      render_success
    else
      render_bad_request_with_message(@account.first_error_message)
    end
  end

  # DELETE /admin/accounts/:id
  def destroy
    authorize! :manage, Admin
    @account.destroy!
    render_success
  end

  private
    def account_params
      params.permit(
        :email,
        :name,
        :password,
        :password_confirmation
      )
    end

    def find_account
      @account = Admin.find(params[:id])
    end
end
