# frozen_string_literal: true

Rails.application.routes.draw do
  direct :rails_public_blob do |blob|
    # Preserve the behaviour of `rails_blob_url` inside these environments
    # where S3 or the CDN might not be configured
    if Rails.env.development? || Rails.env.test?
      route =
        # ActiveStorage::VariantWithRecord was introduced in Rails 6.1
        # Remove the second check if you're using an older version
        if blob.is_a?(ActiveStorage::Variant)
          :rails_representation
        else
          :rails_blob
        end
      route_for(route, blob)
    else
      # Use an environment variable instead of hard-coding the CDN host
      File.join(ENV.fetch('CDN_HOST'), blob.key)
    end
  end

  # webhooks
  post 'webhooks/:key', to: 'webhooks#index'
  post 'webhooks/push', to: 'webhooks#push'

  # surveys
  get 'surveys/:code/:friend_id', to: 'surveys#form', as: 'new_survey_answer_form'
  post 'surveys/:code/:friend_id', to: 'surveys#answer', as: 'survey_answer_form'
  get 'surveys/:code', to: 'surveys#show'
  get 'surveys/:code/:friend_id/answer_success', to: 'surveys#answer_success', as: 'survey_answer_success'
  get 'surveys/:code/:friend_id/answer_error', to: 'surveys#answer_error', as: 'survey_answer_error'
  get 'surveys/:code/:friend_id/already_answer', to: 'surveys#already_answer', as: 'survey_already_answer'

  # User
  constraints Subdomain::UserConstraint.new do
    root to: 'user/home#index'
    devise_for :users, path: Subdomain::UserConstraint.path, controllers: {
      sessions: 'user/sessions',
      passwords: 'user/passwords'
    }
    namespace :user, path: Subdomain::UserConstraint.path do
      root to: 'home#index'
      get '/bot/setup', to: 'bot#setup'
      post '/bot/register', to: 'bot#register'
      resources :home, only: [:index] do
        get :announcements, on: :collection
      end
      resources :channels do
        member do
          get :scenarios
          post :update_last_seen
        end
        resources :messages do
          collection do
            post :send_scenario
            post :send_template
          end
        end
      end
      resources :friends do
        collection do
          get :search
        end
        member do
          post :toggle_locked
          post :toggle_visible
          get :reminders
          post :set_reminder
          get :variables
        end
      end
      resources :broadcasts do
        get :search, on: :collection
        post :copy, on: :member
      end
      resources :scenarios do
        collection do
          get :search
          get :manual
        end
        resources :messages, controller: 'scenario_messages' do
          post :import, on: :collection
        end
        post :copy, on: :member
      end
      resources :auto_responses do
        post :copy, on: :member
      end
      resources :templates do
        post :copy, on: :member
      end
      resources :rich_menus do
        post :copy, on: :member
      end
      resources :surveys do
        member do
          get :answers
          post :copy
        end
      end
      resources :reminders do
        member do
          resources :episodes
        end
      end
      resources :variables do
        member do
          post :copy
        end
      end
      resources :folders
      resources :tags
      get '/emojis/:pack_id', to: 'emojis#show'
      get '/action_objects', to: 'action_objects#index'
      resources :medias do
        post :bulk_delete, on: :collection
      end
      resources :setting, only: [:index] do
        get :edit, on: :collection
        patch :update, on: :collection
        get :friends, on: :member
      end
    end
  end

  # # Admin
  constraints Subdomain::AdminConstraint.new do
    devise_for :admins, path: Subdomain::AdminConstraint.path, controllers: {
      sessions: 'admin/sessions',
      passwords: 'admin/passwords'
    }
    namespace :admin, path: Subdomain::AdminConstraint.path do
      root to: 'users#index'
      resources :users do
        get :search, on: :collection
        get :delete_confirm, on: :member
        get :sso, on: :member
      end
      resources :announcements do
        get :search, on: :collection
        post :upload_image,  on: :collection
      end
    end

    require 'sidekiq/web'
    require 'sidekiq-scheduler/web'
    # Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    #   username == ENV['BASIC_AUTH_ID'] && password == ENV['BASIC_AUTH_PASSWORD']
    # end
    mount Sidekiq::Web => '/sidekiq'
  end
end
