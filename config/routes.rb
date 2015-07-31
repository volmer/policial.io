Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :builds, only: :create

  resources :repositories, only: [:index, :new, :create]
  get '/*id', id: %r{\w+/\w+}, to: 'repositories#show', as: 'repository'
  delete '/*id', id: %r{\w+/\w+}, to: 'repositories#destroy'

  scope '/*repository_id', repository_id: /.*/ do
    resources :builds, only: :show
  end

  root 'repositories#index'
end
