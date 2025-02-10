Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root 'signup#index'

  ## ========= User Authentication ========= ##
  get '/signup', to: 'users#new', as: :signup
  post '/signup', to: 'users#create'

  get '/signin', to: 'signin#new', as: :signin
  post '/signin', to: 'signin#create'
  delete '/signout', to: 'signin#destroy', as: :signout

  ## ========= User Dashboard ========= ##
  get '/dashboard', to: 'dashboard#index', as: :dashboard
  get '/dashboard/data', to: 'dashboard#data'

  ## ========= Profiles ========= ##
  get "/profile", to: "profiles#show", as: :profile
  patch "/profile", to: "profiles#update"

  ## ========= Expenses ========= ##
  resources :expenses, only: [:new, :create, :show]
  get '/expenses', to: 'expenses#new'

  ## ========= Expenditures ========= ##
  resources :expenditures, only: [:create, :update, :show]

  ## ========= Expert Authentication ========= ##
  get '/experts/signup', to: 'experts#new', as: :expert_signup
  post '/experts/signup', to: 'experts#create'
  get '/experts/signin', to: 'experts#login', as: :expert_signin  
  post '/experts/signin', to: 'experts#authenticate' 
  delete '/experts/signout', to: 'experts#logout', as: :expert_signout

  ## ========= Expert Dashboard ========= ##
  get 'expert_dashboard', to: 'experts#dashboard'
  get '/experts/:id/edit', to: 'experts#edit', as: 'edit_expert'
end
