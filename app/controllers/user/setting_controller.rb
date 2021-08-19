class User::SettingController < User::ApplicationController
  include User::SettingHelper
  def index
    @line_account = current_user.line_account
  end
end
