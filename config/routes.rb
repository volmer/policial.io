Rails.application.routes.draw do
  resources :builds, only: [:index, :show, :create]

  root to: 'builds#index'
end
