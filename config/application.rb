require_relative "boot"

require 'logger'
require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    
    # Timezone configuration
    config.time_zone = 'Asia/Tokyo'
    
    # I18n configuration
    config.i18n.default_locale = :ja
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    
    # Autoload paths
    config.autoload_paths += %W[#{config.root}/lib #{config.root}/services #{config.root}/builders]
    
    # Action Cable configuration
    config.action_cable.mount_path = '/cable'
    config.action_cable.disable_request_forgery_protection = true
    
    # Assets configuration
    config.assets.precompile += %w[*.png *.jpg *.jpeg *.gif]
    
    # Filter parameters
    config.filter_parameters << :password
    
    # Generators configuration
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: true
      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end
    
    # CORS middleware configuration
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end
    
    # ActiveStorage configuration
    config.active_storage.content_types_to_serve_as_binary -= [
      'image/svg+xml'
    ]
    
    # Active Job configuration
    config.active_job.queue_adapter = :sidekiq
  end
end
