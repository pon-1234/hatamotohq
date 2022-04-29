# frozen_string_literal: true

class User::SitesController < User::ApplicationController
  before_action :find_site, except: [:index, :create, :new]

  # GET /user/sites
  def index
    if request.format.json?
      @folders = Folder.accessible_by(current_ability).type_site.includes([:sites])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @site_id = params[:id]
    @line_friend_count = @site.client.line_friends.count
    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    site = Site.new site_params
    site.client_id = current_user.client_id
    unless site.save
      render_bad_request_with_message(site.first_error_message)
    else
      redirect_to user_sites_path, notice: 'サイトの作成は完了しました'
    end
  end

  # GET /user/sites/:id/edit
  def edit
    @site_id = params[:id]
  end

  # PATCH /user/sites/:id
  def update
    unless @site.update!(site_params)
      render_bad_request_with_message(@site.first_error_message)
    end
  end

  # DELETE /user/sites/:id
  def destroy
    @site.destroy!
    render_success
  end

  # GET /user/sites/:id/scenarios
  def scenarios
    @site_measurements = @site.site_measurements.scenario_messages_of_site
  end

  # GET /user/sites/:id/broadcasts
  def broadcasts
    @site_measurements = @site.site_measurements.broadcast_messages_of_site
  end

  private
    def site_params
      params.require(:site).permit :folder_id, :url, :name
    end

    def find_site
      @site = Site.find(params[:id])
    end
end
