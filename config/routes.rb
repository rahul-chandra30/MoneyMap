Rails.application.routes.draw do
  get "expenditures/create"
  get "expenditures/update"
  get "expenditures/show"
  get "expenses/new"
  get "expenses/create"
  get "expenses/update"
  get "profiles/show"
  get "profiles/update"
  get "up" => "rails/health#show", as: :rails_health_check

  # Sign Up routes
 post '/signup', to: 'users#create' 
  get '/signup', to: 'users#new'

  # Sign In routes
  get 'signin', to: 'signin#new'
  post 'signin', to: 'signin#create'
  delete 'signout', to: 'signin#destroy'

  # Root path
  root 'signup#index'

  # Dashboard
  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/data', to: 'dashboard#data'

  # Profiles
  get "/profile", to: "profiles#show"
  patch "/profile", to: "profiles#update"

  # ExpensesController
resources :expenses, only: [:new, :create]

  get '/expenses', to: 'expenses#new'

  get '/expenses/:year/:month', to: 'expenses#show'  

  # Expenditure routes
  resources :expenditures, only: [:create, :update, :show]
  get '/expenditures/:year/:month', to: 'expenditures#show'
  
  # Clean up expense routes
  resources :expenses, only: [:new, :create]
end
