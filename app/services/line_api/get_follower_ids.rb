# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::GetFollowerIds < LineApi::BaseRequest
  def perform
    headers = { 'Authorization' => "Bearer #{@access_token}" }
    cursor = nil
    friend_ids = []
    loop do
      query = { start: cursor }
      options = {
        headers: headers,
        query: query
      }
      response = self.class.get('/bot/followers/ids', options)
      # Break if could not get follower list, cause account plan limitation or somehow
      break if response.code != 200

      # If could get follower list
      json_body = JSON.parse(response.body)
      ids = json_body['userIds']
      cursor = json_body['next']
      break if cursor.blank? || ids.blank?
      friend_ids << ids
    end
    friend_ids
  end
end
