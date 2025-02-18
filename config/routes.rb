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
  get 'expert_signup', to: 'experts#new'
  post 'expert_signup', to: 'experts#create'
  get 'expert_signin', to: 'experts#login'
  post 'expert_signin', to: 'experts#authenticate'  
  delete 'expert_signout', to: 'experts#logout', as: :expert_signout

  ## ========= Expert Dashboard ========= ##
  get 'expert_dashboard', to: 'experts#dashboard'
  get '/experts/:id/edit', to: 'experts#edit', as: 'edit_expert'

  ## ========= Expert Opinion ========= ##
  get '/expert_opinion', to: 'expert_opinion#index', as: :expert_opinion

  # Expert routes
  resources :experts do
    member do
      patch 'update_profile'
    end
  end

  ## ========= Payments ========= ##
  resources :bookings, only: [:create, :index] do
      collection do
      post 'payment_callback'
    end
  end

  # Razorpay webhook route
  post '/razorpay_webhook', to: 'webhooks#razorpay'

  # Chat routes
  get 'user/chat', to: 'chat_rooms#user_chat', as: 'user_chat'
  get 'expert/chat', to: 'chat_rooms#expert_chat', as: 'expert_chat'
  post 'chat_rooms/create_or_find', to: 'chat_rooms#create_or_find'
  resources :chat_rooms, only: [] do
    resources :messages, only: [:create]
  end

  mount ActionCable.server => '/cable'

end
