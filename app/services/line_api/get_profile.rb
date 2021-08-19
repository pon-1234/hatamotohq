module LineApi
  # Get a list of users who added your LINE Official Account as a friend
  class GetProfile < LineApi::BaseRequest
    def initialize(channel_id, channel_secret, user_id)
      @user_id = user_id
      super(channel_id, channel_secret)
    end

    def perform
      headers = { "Authorization" => "Bearer #{@access_token}" }
      options = {
        headers: headers
      }
      response = self.class.get("/bot/profile/#{@user_id}", options)
      return nil if response.code != 200
      json_body = JSON.parse(response.body)
      return json_body
    end
  end
end