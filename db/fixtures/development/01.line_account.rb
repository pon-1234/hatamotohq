# frozen_string_literal: true

LineAccount.seed do |s|
  s.id = 1
  s.owner_id = 1
  s.line_name = 'テスト用'
  s.line_channel_id = '1656309479'
  s.line_channel_secret = '525b11a92f8ba129c6736016685c65b7'
  s.webhook_url = '1kVhS4vKis'
  s.bot_initialized = true
  s.status = 'active'
end
