# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  authenticate :admin_user do
    mount Sidekiq::Web => '/admin/sidekiq'
  end
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :playlists, only: %i[index show] do
        resources :comments, only: %i[index create]
        resource :reaction, only: %i[show create destroy]
      end
      resources :users, only: %i[index create]

      post :login, to: 'authentication#create'
      post :refresh, to: 'refresh#create'
      delete :logout, to: 'authentication#destroy'

      namespace :my do
        resource :account, only: %i[show update destroy]
        resources :reactions, only: %i[index]

        resources :playlists, only: %i[index create update destroy] do
          resources :playlist_songs, only: %i[create destroy]
        end
        resources :playlists, only: :update do
          member do
            resource :playlist_type, only: :update
          end
        end

        resources :friendships, only: %i[index create update destroy show]
      end

      resources :songs, only: [:index]

      resources :genres, only: [:index]
      get :home_playlists, to: 'home_playlists#index'
      get '/options/:handle', to: 'options#show'
    end
  end
end
