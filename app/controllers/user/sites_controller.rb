# frozen_string_literal: true

class User::SitesController < User::ApplicationController
  def index; end

  def new
  end

  def create
    site = Site.new site_params
    code = loop do
      result = SecureRandom.alphanumeric(6)
      break result unless Site.exists?(code: result)
    end
    site.code = code
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
