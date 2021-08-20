# frozen_string_literal: true

Rails.application.routes.draw do
  # webhooks
  post 'webhooks/:key', to: 'webhooks#index'
  post 'webhooks/push', to: 'webhooks#push'

  # User
  constraints Subdomain::UserConstraint.new do
    # root to: 'user/home#index'
    devise_for :users, path: Subdomain::UserConstraint.path, controllers: {
      sessions: 'user/sessions',
      passwords: 'user/passwords'
    }
    namespace :user, path: Subdomain::UserConstraint.path do
      root to: 'home#index'
      get '/bot/setup', to: 'bot#setup'
      post '/bot/register', to: 'bot#register'

      resources :line_friends do
        collection do
          get :search
        end
      end

      resources :tags

      resources :setting, only: [:index] do
        collection do
          get :edit
          patch :update
        end
      end
    end
  end

  # # Admin
  # constraints Subdomain::AdminConstraint.new do
  #   root to: 'admin/home#index'
  #   devise_for :admins, path: Subdomain::AdminConstraint.path, controllers: {
  #     sessions: 'admin/sessions',
  #     passwords: 'admin/passwords'
  #   }
  #   namespace :admin, path: Subdomain::AdminConstraint.path do
  #     root to: 'home#index'
  #   end
  # end
end
