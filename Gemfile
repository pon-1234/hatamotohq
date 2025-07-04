# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.6'

#  Core gem
gem 'dotenv-rails'
gem 'rails', '~> 7.1.5'
gem 'pg', '~> 1.1'
gem 'puma', '~> 6.0'
gem 'sass-rails', '>= 6'
gem 'jbuilder', '~> 2.7'
gem 'jsbundling-rails'
gem 'cssbundling-rails'
gem 'vite_rails'
# gem 'webpacker', '~> 5.0' # Removed - using jsbundling-rails instead
gem 'browser', require: 'browser/browser'
gem 'httparty'
gem 'line-bot-api'

# Active Model
gem 'activerecord_json_validator'
gem 'paranoia', '~> 2.2'
gem 'ransack'
gem 'seed-fu'
gem 'cancancan'

# Hashie is a collection of classes and mixins that make Ruby hashes more powerful.
gem 'hashie'

# Ruby 3.3 compatibility
gem 'logger'

# Search engine
gem 'searchkick'

# Authentication
gem 'devise'
gem 'devise-security'
gem 'devise_token_auth'
gem 'devise-async'
gem 'authtrail'
gem 'rack-cors', require: 'rack/cors'
# Json web token for authentication apis
gem 'jwt'

# Active Storage
gem 'active_storage_validations'
gem 'aws-sdk-s3'
gem 'google-cloud-storage', '~> 1.11', require: false
gem 'image_processing'

# csv,exel import/export, zip
gem 'activerecord-import'
gem 'roo'
gem 'rubyzip'
gem 'google-apis-sheets_v4'

# Localization
gem 'enum_help'
gem 'rails-i18n'

# Pagination
gem 'kaminari'

# Worker
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'redis-namespace'

# Push notification
gem 'fcm'

# QRcode
gem 'rqrcode'

# Monitoring
gem 'sentry-ruby'
gem 'sentry-rails'
# gem 'ddtrace'
gem 'logster'

# support for format JSON
gem 'active_model_serializers', '~> 0.10.0'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'annotate'
  gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-yarn'
  gem 'ed25519', '>= 1.2', '< 2.0'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'meta_request'
  # Brakeman is a static analysis tool which checks Ruby on Rails applications for security vulnerabilities.
  gem 'brakeman'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'pry-rails'
end

group :test do
  # unit test
  gem 'database_cleaner-active_record'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 4.0.1'
  gem 'simplecov', require: false
end
