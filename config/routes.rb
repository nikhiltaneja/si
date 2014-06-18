require 'sidekiq/web'

SwiftIntro::Application.routes.draw do
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect("/")
  get 'signout', to: 'sessions#destroy', as: 'signout'

  root to: 'users#show'
  
  resources :users, except: [:index] do
    get 'matches/prior_matches', to: 'matches#prior_matches'
    put 'matches/:id/send_potential_match_email', to: 'matches#send_potential_match_email', as: 'send_potential_match_email'
    resources :matches do
      resources :messages, only: [:create]
    end
    get 'messages/inbox', to: 'messages#inbox', as: 'messages_inbox'
    get 'messages/sent', to: 'messages#sent', as: 'messages_sent'
    post 'messages/send_message', to: 'messages#send_message', as: 'send_message'
  end

  mount Sidekiq::Web, at: '/admins/sidekiq'

  get 'admins/requests'
  get 'admins/metrics'
  get 'admins/queue'
  get 'admins/:id/past_matches', to: 'admins#past_matches', as: 'admins_past_matches'

  get 'users/:id/invite', to: 'users#invite', as: 'user_invite'
  get 'users/:id/premium', to: 'users#premium', as: 'user_premium'
  get 'users/:id/settings', to: 'users#settings', as: 'user_settings'
  post 'users/:id/delete_account', to: 'users#delete_account', as: 'user_delete_account'

  resources :admins, only: [:index, :show]
  resources :dashboard, only: [:index]

  get '/contact', to: 'dashboard#contact', as: 'contact'
  get '/faq', to: 'dashboard#faq', as: 'faq'
  get '/privacy', to: 'dashboard#privacy', as: 'privacy'

  get '/terms', to: 'dashboard#terms', as: 'terms'

  get '/:ref', to: 'dashboard#index'
end
