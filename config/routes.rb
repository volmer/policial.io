Rails.application.routes.draw do
  root to: 'home#index'
  resources :repositories, only: [:index, :create]

  get '/auth/github/callback', to: 'auth#github'
  get '/logout', to: 'auth#logout'

  resources :builds, only: :create
  scope '/*repo' do
    resources :builds, only: [:index, :show]

    root to: 'builds#index', as: :root_s
  end
end
