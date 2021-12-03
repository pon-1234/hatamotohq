# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class LineApi::GetFollowerIds < LineApi::BaseRequest
  def perform
    cursor = nil
    friend_ids = []
    loop do
      response = client.get_follower_ids(cursor)
      # Break if could not get follower list, cause account plan limitation or somehow
      break if response.code != HTTP_OK
      # If could get follower list
      result = JSON.parse(response.body)
      ids = result['userIds']
      cursor = result['next']
      break if cursor.blank? || ids.blank?
      friend_ids << ids
    end
    friend_ids
  end
end
