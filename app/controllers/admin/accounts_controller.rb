# frozen_string_literal: true

class Admin::AccountsController < Admin::ApplicationController
  before_action :find_account, only: [:show, :edit, :update, :destroy]

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

  def create
    @account = Admin.new(account_params)
    if !@account.save
      render_bad_request_with_message(@account.first_error_message)
    end
  end

  def update
    if !@account.update(account_params)
      render_bad_request_with_message(@account.first_error_message)
    end
  end

  def destroy
    @account.destroy!
    render_success
  end

  private
    def account_params
      params.permit(
        :email,
        :name,
        :status,
        :password,
        :password_confirmation
      )
    end

    def find_account
      @account = Admin.find(params[:id])
    end
end
