# frozen_string_literal: true

class User::HomeController < User::ApplicationController
  # GET /user/home
  def index
    redirect_to user_channels_path unless Current.user.admin?
    @friend_count = Current.user.line_account.line_friends.active.where(locked: false).count
    @messages = Current.user.line_account.latest_messages
    @insight = Insight.where(line_account: Current.user.line_account).monthly.this_month.first
  end

  # GET /user/home/announcements
  def announcements
    @announcements = Announcement.for_user.page(params[:page])
  end
end
