Rails.application.routes.draw do
  root 'static_pages#home'
  post 'sign_up', to: 'users#create'
  get 'sign_up', to: 'users#new'

  # Routes form confirmations
  resources :confirmations, only: %i[create edit new], param: :confirmation_token

  # Routes for password
  resources :passwords, only: %i[create edit new update], param: :password_reset_token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
