# frozen_string_literal: true

class GoogleApi::GetServiceTokens
  include HTTParty

  def perform(auth_code)
    params = {
      client_id: ENV['GOOGLE_OAUTH_CLIENT_ID'],
      client_secret: ENV['GOOGLE_OAUTH_CLIENT_SECRET'],
      redirect_uri: 'postmessage',
      grant_type: 'authorization_code',
      code: auth_code
    }
    response = self.class.post('https://accounts.google.com/o/oauth2/token', query: params) rescue nil
    return nil if response.code != 200
    JSON.parse(response.body)
  end
end
