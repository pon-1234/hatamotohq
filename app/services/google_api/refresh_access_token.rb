# frozen_string_literal: true

class GoogleApi::RefreshAccessToken
  include HTTParty

  def perform(refresh_token)
    params = {
      client_id: ENV['GOOGLE_OAUTH_CLIENT_ID'],
      client_secret: ENV['GOOGLE_OAUTH_CLIENT_SECRET'],
      refresh_token: refresh_token,
      grant_type: 'refresh_token'
    }
    response = self.class.post('https://accounts.google.com/o/oauth2/token', query: params) rescue nil
    return nil if response.code != 200
    JSON.parse(response.body)['access_token']
  end
end
