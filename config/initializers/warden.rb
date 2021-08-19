# frozen_string_literal: true

Warden::Strategies.add(:authentication_token, ApiTokenStrategy)
