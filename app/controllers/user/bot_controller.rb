# frozen_string_literal: true

class User::BotController < User::ApplicationController
  skip_before_action :ensure_bot_initialized
  include User::BotHelper
  include LineApi

  def setup
  end

  def register
    if valid_bot?(bot_params[:line_channel_id], bot_params[:line_channel_secret])
      line_account = current_user.line_account
      line_account.bot_initialized = true
      line_account.update!(bot_params)
      redirect_to user_root_path, flash: { success: 'ボットの設定は完了しました。' }
    else
      redirect_to user_bot_setup_path, flash: { error: 'ボット設定は失敗しました。' }
    end
  end

  private
    def bot_params
      params.require(:bot)
        .permit(
          :line_name,
          :line_user_id,
          :line_channel_id,
          :line_channel_secret
        )
    end
end
