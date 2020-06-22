Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'confirmations',
    omniauth_callbacks: 'omniauth_callbacks'
  }
  resources :users, only: [:show]
  
  root to: 'pages#home'

  resources :services

  resources :services, only: [:show] do
    resources :bookings, only: [:new, :create]
  end

  resources :bookings, only: [:index, :show, :destroy, :edit, :update]
  
  resources :services, only: [:show] do
    resources :reviews, only: [:new, :create]
  end
  
  resources :reviews, only: [:index, :show]
  resources :users, only: [:show, :edit, :update]

  #path for dashboards
  get 'dashboard' => 'dashboards#index'

  #path for payments
  get 'payment_method' => 'users#payment'
  get 'payout_method' => 'users#payout'
  post 'add_card' => "users#add_card"

  #path for chat
  resources :conversations, only: [:index, :create]  do
    resources :messages, only: [:index, :create]
  end
  mount ActionCable.server => '/cable'

  #path for notification
  get '/notifications' => 'notifications#index'

  #Path for Provider Calendar
  get '/provider_calendar' => "calendars#index"
  # get '/tagged', to: "services#tagged", as: :tagged
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
