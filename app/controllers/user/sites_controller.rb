# frozen_string_literal: true

class User::SitesController < User::ApplicationController
  def index
    if request.format.json?
      @folders = Folder.accessible_by(current_ability).type_site.includes([:sites])
    end
    respond_to do |format|
      format.html
      format.json
    end
  end

  def new
  end

  def create
    site = Site.new site_params
    unless site.save
      render_bad_request_with_message(site.first_error_message)
    else
      redirect_to user_sites_path, notice: 'サイトの作成は完了しました'
    end
  end

  private
    def site_params
      params.require(:site).permit :folder_id, :url
    end
end
