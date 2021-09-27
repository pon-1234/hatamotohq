# frozen_string_literal: true

class User::HomeController < User::ApplicationController
  # GET /user/home
  def index
    @friend_count = Current.user.line_account.line_friends.count
    @messages = Current.user.line_account.latest_messages
  end

  # GET /user/home/announcements
  def announcements
    @announcements = Announcement.published.before(Time.zone.now).page(params[:page])
  end
end
