require 'sidekiq/web'

SwiftIntro::Application.routes.draw do
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  root to: 'matches#show'

  get 'users/request_received'
  
  resources :users, except: [:index] do
    resources :matches
  end

  get 'admins/requests'

  resources :admins, only: [:index, :show]
  resources :dashboard, only: [:index]

  mount Sidekiq::Web, at: '/sidekiq'
  
end
