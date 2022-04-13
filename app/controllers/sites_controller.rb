# frozen_string_literal: true

class SitesController < ApplicationController
  def statistic
    site_reference = SiteReference.find params[:code]
    site_measurement = site_reference.site_measurement
    site = site_measurement.site
    line_friend = site_reference.line_friend
    # Update statistic information
    site.click_count = site.click_count.to_i.next
    site_measurement.click_count = site_measurement.click_count.to_i.next
    unless SiteLineFriend.exists?(site_id: site.id, line_friend_id: line_friend.id)
      site.visitor_count = site.visitor_count.next
      SiteLineFriend.create!(site_id: site.id, line_friend_id: line_friend.id)
    end
    unless SiteMeasurementsLineFriend.exists?(site_measurement_id: site_measurement.id, line_friend_id: line_friend.id)
      site_measurement.visitor_count = site_measurement.visitor_count.next
      SiteMeasurementsLineFriend.create!(site_measurement_id: site_measurement.id, line_friend_id: line_friend.id)
    end
    [site, site_measurement].each(&:save!)

    # Handle postback actions
    SiteActionHandlerJob.perform_later(line_friend, site_measurement.actions.first['data'])
    redirect_to (site_measurement.redirect_url || site.url)
  rescue => exception
    puts exception.message
  end
end
