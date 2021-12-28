# frozen_string_literal: true

LineAccount.seed do |s|
  s.id = 1
  s.owner_id = 1
  s.line_name = 'テスト用'
  s.channel_id = '1654702076'
  s.channel_secret = '94c3950c2fe706b9e507821237737974'
  s.webhook_url = '1kVhS4vKis'
  s.bot_initialized = true
end
