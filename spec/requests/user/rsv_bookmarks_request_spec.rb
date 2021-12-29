# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User::RsvBookmarks', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/user/rsv_bookmarks/index'
      expect(response).to have_http_status(:success)
    end
  end
end
