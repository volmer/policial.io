Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  root to: 'repositories#index'
  resources :repositories, only: [:index, :new, :create, :destroy]
  resources :builds, only: :create
  scope '/*repo', repo: /.*/ do
    resources :builds, only: [:index, :show]
    root to: 'builds#index', as: :root_s
  end
end
