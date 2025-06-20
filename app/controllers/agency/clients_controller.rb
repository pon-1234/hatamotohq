# frozen_string_literal: true

class Agency::ClientsController < Agency::ApplicationController
  before_action :find_client, only: [:edit, :update, :sso, :destroy]

  DOTS_HOME_MAIL_SUFFIX = '@dot-homes.jp'

  # GET /agency/clients
  def index
    if request.format.json?
      @params = params[:q]
      @q = current_agency.clients.includes([:line_account]).ransack(@params)
      @clients = @q.result.page(params[:page])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /agency/clients/new
  def new
  end

  # POST /agency/clients
  def create
    ApplicationRecord.transaction do
      # Create a new client
      client = Client.new(params.permit(:name, :address, :phone_number, :status))
      client.agency = current_agency
      client.gauth_visible = params[:admin][:email].end_with? DOTS_HOME_MAIL_SUFFIX
      client.save!
      client.create_line_account
      # Create client admin
      user = User.new(params.require(:admin).permit(:name, :email, :password, :password_confirmation))
      user.client = client
      user.role = :admin
      user.save!
      @client = client
    end
  rescue => e
    render_bad_request_with_message(e.message)
  end

  # PATCH /agency/clients/:id
  def update
    @client.update!(params.permit(:name, :address, :phone_number, :status))
  rescue => e
    render_bad_request_with_message(e.message)
  end

  # DELETE /agency/clients/:id
  def destroy
    @client.destroy
    render_success
  rescue => e
    render_bad_request_with_message(e.message)
  end

  # GET /agency/clients/:id/sso
  def sso
    if @client.active?
      sign_in @client.admin
      redirect_to user_root_path
    else
      redirect_to agency_clients_path, flash: { warning: 'クライアントはブロック中ですので、ログインできませんでした。' }
    end
  end

  private
    def find_client
      @client = Client.find(params[:id])
    end
end
