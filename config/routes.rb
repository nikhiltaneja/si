SwiftIntro::Application.routes.draw do
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  root to: 'matches#show'
  
  resources :users, except: [:index] do
    resources :matches
  end

  resources :dashboard, only: [:index]
  resources :admins, only: [:index, :show]

end
