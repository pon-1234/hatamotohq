# frozen_string_literal: true

class SitesController < ApplicationController
  AUTOMATIC_REQUEST_USER_AGENT_REGEX = /^facebookexternalhit(.+)line-poker(.+)$/

  def statistic
    return if is_automatic_request?
    site_reference = SiteReference.find_by code: params[:code]
    site_measurement = site_reference.site_measurement
    site = site_measurement.site
    line_friend = site_reference.line_friend
    # Update statistic information
    site.click_count = site.click_count.to_i.next
    site_measurement.click_count = site_measurement.click_count.to_i.next
    unless SitesLineFriend.exists?(site_id: site.id, line_friend_id: line_friend.id, visited: true)
      site.visitor_count = site.visitor_count.to_i.next
      sites_line_friend = SitesLineFriend.find_or_create_by(site_id: site.id, line_friend_id: line_friend.id)
      sites_line_friend.update! visited: true
    end
    unless SiteMeasurementsLineFriend.exists?(site_measurement_id: site_measurement.id, line_friend_id: line_friend.id, visited: true)
      site_measurement.visitor_count = site_measurement.visitor_count.to_i.next
      site_measurement_friend = SiteMeasurementsLineFriend.find_or_create_by(site_measurement_id: site_measurement.id, line_friend_id: line_friend.id)
      site_measurement_friend.update! visited: true
    end
    site.save!
    site_measurement.save!

    # Handle postback actions
    SiteActionHandlerJob.perform_later(line_friend, site_measurement.actions.first['data']) if site_measurement.actions.present?
    redirect_to (site_measurement.redirect_url || site.url)
  rescue => exception
    puts exception.message
  end

  private
    def is_automatic_request?
      request.user_agent.match(AUTOMATIC_REQUEST_USER_AGENT_REGEX)
    end
end
