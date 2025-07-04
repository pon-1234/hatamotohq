# frozen_string_literal: true

class User::BotController < User::ApplicationController
  layout 'auth'
  skip_before_action :ensure_bot_initialized
  include User::BotHelper
  include LineApi

  def setup
    @bot = Current.user.line_account
  end

  def register
    if valid_bot?(bot_params[:channel_id], bot_params[:channel_secret])
      line_account = current_user.line_account
      line_account.bot_initialized = true
      line_account.update!(bot_params)
      line_account.get_messages_quota
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
          :channel_id,
          :channel_secret,
          :liff_id
        )
    end
end
