Rails.application.routes.draw do
  resources :builds, only: [:index, :show, :create]
  resources :repositories, only: [:index, :create]

  get '/auth/github/callback', to: 'auth#github'
  get '/logout', to: 'auth#logout'

  root to: 'home#index'
end
