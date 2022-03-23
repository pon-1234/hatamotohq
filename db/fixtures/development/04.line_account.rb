# frozen_string_literal: true

# Schema sometimes need to be reloaded before running a seed
LineAccount.reset_column_information()
LineAccount.seed do |s|
  s.id = 1
  s.client = Client.first
  s.line_user_id = '@331lkuph'
  s.line_name = 'テストボット１'
  s.display_name = 'テストボット１'
  s.channel_id = '1656592876'
  s.channel_secret = '238c2e5b22847171a2ade20c0828d5fd'
  s.webhook_url = '1kVhS4vKis'
  s.bot_initialized = true
end
