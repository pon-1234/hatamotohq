# frozen_string_literal: true

class User::HomeController < User::ApplicationController
  def index
    @notices =[]
    @friend_count = Current.user.line_account.line_friends.count
    @messages = Current.user.line_account.latest_messages
    @announcements = Announcement.announcement_published.order(created_at: :desc).page(params[:page])
  end
end
