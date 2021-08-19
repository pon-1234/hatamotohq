# frozen_string_literal: true

class ApiTokenStrategy < Warden::Strategies::Base
  def valid?
    api_token.present?
  end

  def authenticate!
    user = User.find_by(api_token: api_token)

    if user
      success!(user)
    else
      fail!('Invalid email or password')
    end
  end

  private
    def api_token
      env['Authorization'].to_s.remove('Bearer ')
    end
end
