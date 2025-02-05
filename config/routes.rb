Rails.application.routes.draw do
  get "expenses/new"
  get "expenses/create"
  get "expenses/update"
  get "profiles/show"
  get "profiles/update"
  get "up" => "rails/health#show", as: :rails_health_check

  # Sign Up routes
  get 'signup', to: 'signup#index'
  post 'signup', to: 'signup#create'

  # Sign In routes
  get 'signin', to: 'signin#new'
  post 'signin', to: 'signin#create'
  delete 'signout', to: 'signin#destroy'

  # Root path
  root 'signup#index'

  # Dashboard
  get 'dashboard', to: 'dashboard#index'

  # Profiles
  get "/profile", to: "profiles#show"
  patch "/profile", to: "profiles#update"

  # ExpensesController
resources :expenses, only: [:new, :create]

  get '/expenses', to: 'expenses#new'

  get '/expenses/:year/:month', to: 'expenses#show'  
end
