Rails.application.routes.draw do
  resources :builds, only: [:index, :show, :create]

  get '/auth/github/callback', to: 'auth#github'
  get '/logout', to: 'auth#logout'

  root to: 'builds#index'
end
