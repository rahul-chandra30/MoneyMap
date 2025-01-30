Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  # Sign Up routes
  get 'signup', to: 'signup#index'
  post 'signup', to: 'signup#create'

  # Sign In routes
  get 'signin', to: 'signin#index'
  post 'signin', to: 'signin#create'
  delete 'logout', to: 'signin#destroy'

  # Root path
  root 'signup#index'
end