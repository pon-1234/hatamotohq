# frozen_string_literal: true

# Get a list of users who added your LINE Official Account as a friend
class Pms::GetRoom < Pms::BaseRequest
  def perform(params)
    self.class.get('/roomtypes/allStock', headers: auth_header, query: params) rescue nil
  end
end
