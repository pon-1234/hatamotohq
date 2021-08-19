# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    config.load_defaults 6.0
    config.time_zone = 'Asia/Tokyo'

    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.autoload_paths += %W[#{config.root}/lib #{config.root}/services]
    config.action_cable.mount_path = '/cable'
    config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif]
    config.filter_parameters << :password
    config.generators do |g|
      g.test_framework  :rspec, fixture: true
      g.view_specs      false
      g.helper_specs    false
    end
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          methods: [:get, :post, :options, :delete, :put, :patch]
      end
    end
    ActiveStorage::Engine.config
      .active_storage
      .content_types_to_serve_as_binary
      .delete('image/svg+xml')
    ActiveSupport::Deprecation.silenced = true
    config.active_job.queue_adapter = :sidekiq
  end
end
