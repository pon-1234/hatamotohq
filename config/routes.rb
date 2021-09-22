# frozen_string_literal: true

Rails.application.routes.draw do
  # webhooks
  post 'webhooks/:key', to: 'webhooks#index'
  post 'webhooks/push', to: 'webhooks#push'

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
      resources :channels do
        get :scenarios, on: :member
        resources :messages do
          post :send_scenario, on: :collection
          post :send_template, on: :collection
        end
      end
      resources :friends do
        get :search, on: :collection
      end
      resources :broadcasts do
        get :search, on: :collection
        get :delete_confirm, on: :member
      end
      resources :scenarios do
        get :search, on: :collection
        get :manual, on: :collection
        resources :messages, controller: 'scenario_messages' do
          get :delete_confirm, on: :member
          post :import, on: :collection
        end
        get :delete_confirm, on: :member
        get :copy_confirm, on: :member
        post :copy, on: :member
      end
      resources :auto_responses
      resources :templates do
        post :copy, on: :member
      end
      resources :folders
      resources :rich_menus
      resources :tags
      get '/emojis/:pack_id', to: 'emojis#show'
      get '/action_objects', to: 'action_objects#index'
      resources :medias
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
        get :delete_confirm, on: :member
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
