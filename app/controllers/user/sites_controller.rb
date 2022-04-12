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

  def redirect
    site_measurement = SiteMeasurement.find params[:site_measurement_id]
    site = Site.find_by_code params[:code]
    line_friend = LineFriend.find params[:line_user_id]
    # Update statistic information
    site.click_count = site.click_count.to_i.next
    site_measurement.click_count = site_measurement.click_count.to_i.next
    unless SiteLineFriend.exists?(site_id: site_measurement.site_id, line_friend_id: line_friend.id)
      site.visitor_count = site.visitor_count.next
      SiteLineFriend.create!(site_id: site_measurement.site_id, line_friend_id: line_friend.id)
    end
    unless SiteMeasurementsLineFriend.exists?(site_measurement_id: site_measurement.id, line_friend_id: line_friend.id)
      site_measurement.visitor_count = site_measurement.visitor_count.next
      SiteMeasurementsLineFriend.create!(site_measurement_id: site_measurement.id, line_friend_id: line_friend.id)
    end
    [site, site_measurement].each(&:save!)

    # Todo
    # handle action
    redirect_to (site_measurement.redirect_url || site.url)
  rescue => exception
    puts exception.message
  end

  private
    def site_params
      params.require(:site).permit :folder_id, :url
    end
end
