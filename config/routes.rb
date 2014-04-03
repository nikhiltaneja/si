require 'sidekiq/web'

SwiftIntro::Application.routes.draw do
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect("/")
  get 'signout', to: 'sessions#destroy', as: 'signout'

  root to: 'users#show'
  
  resources :users, except: [:index] do
    resources :matches
  end

  mount Sidekiq::Web, at: '/admins/sidekiq'

  get 'admins/requests'

  resources :admins, only: [:index, :show]
  resources :dashboard, only: [:index]
  
end
