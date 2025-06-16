# frozen_string_literal: true

Rails.configuration.to_prepare do
  Warden::Strategies.add(:authentication_token, ApiTokenStrategy)
end
