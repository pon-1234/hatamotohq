# frozen_string_literal: true

class User::SettingController < User::ApplicationController
  include User::SettingHelper
  before_action :find_line_account, only: [:index, :edit]

  # GET /user/setting
  def index
  end

  # GET /user/setting/edit
  def edit
  end

  # PATCH /user/setting
  def update
    @line_account = LineAccount.find(setting_params[:id])
    if @line_account.update(setting_params)
      redirect_to user_setting_index_path, flash: { success: '設定の変更は完了しました。' }
    else
      redirect_to edit_user_setting_index_path, flash: { error: @line_account.first_error_message }
    end
  end

  private
    def setting_params
      params.require(:setting)
      .permit(
        :id,
        :line_user_id,
        :line_name,
        :display_name
      )
    end

    def find_line_account
      @line_account = current_user.line_account
    end
end
