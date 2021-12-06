# frozen_string_literal: true

class Admin::AccountsController < Admin::ApplicationController
  before_action :find_account, only: [:show, :edit, :update, :destroy]

  # GET /admin/accounts
  def index
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
    @account = Admin.new(account_params)
    @account.role = :admin
    if !@account.save
      render_bad_request_with_message(@account.first_error_message)
    end
  end

  # PATCJ /admin/accounts/:id
  def update
    if !@account.update(account_params)
      render_bad_request_with_message(@account.first_error_message)
    end
  end

  # DELETE /admin/accounts/:id
  def destroy
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
