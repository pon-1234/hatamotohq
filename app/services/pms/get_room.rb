# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class Pms::GetRoom < Pms::BaseRequest
  def perform(params)
    response = self.class.get('/roomtypes/allStock', headers: auth_header, query: params) rescue nil
    return nil if response.code != 200
    JSON.parse(response.body)
  end
end
