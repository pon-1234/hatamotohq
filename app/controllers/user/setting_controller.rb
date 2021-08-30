# frozen_string_literal: true

class User::SettingController < User::ApplicationController
  include User::SettingHelper

  # GET /user/setting
  def index
    @line_account = current_user.line_account
  end

  # GET /user/setting/edit
  def edit
  end

  # PATCH /user/setting
  def update
    # TODO: can edit: line_user_id, line_name, display_name
  end
end
