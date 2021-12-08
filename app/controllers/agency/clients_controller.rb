# frozen_string_literal: true

class Agency::ClientsController < Agency::ApplicationController
  # GET /agency/clients
  def index
    if request.format.json?
      @params = params[:q]
      @q = Client.ransack(@params)
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
    # Create a new client
    client = Client.new
    client.name = params[:name]
    client.address = params[:address]
    client.phone_number = params[:phone_number]
    client.save!
    # Create client admin
    user = User.new(params.require(:admin).permit(:name, :email, :password, :password_confirmation))
    user.client = client
    user.role = :admin
    user.save!
    @client = client
  rescue => e
    render_bad_request_with_message(e.message)
  end

  # PATCH /agency/clients/:id
  def update
    
  end
end
