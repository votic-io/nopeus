Shoppe::Engine.routes.draw do
  get 'attachment/:id/:filename.:extension' => 'attachments#show'

  resources :customers do
    post :search, on: :collection
    resources :addresses
  end

  resources :product_categories do
    resources :localisations, controller: 'product_category_localisations'
  end
  resources :products do
    resources :variants
    resources :localisations, controller: 'product_localisations'
    collection do
      get :import
      post :import
    end
  end
  resources :orders do
    collection do
      post :search
    end
    member do
      post :accept
      post :reject
      post :ship
      get :despatch_note
    end
    resources :payments, only: [:create, :destroy] do
      match :refund, on: :member, via: [:get, :post]
    end
  end
  resources :stock_level_adjustments, only: [:index, :create]
  resources :delivery_services do
    resources :delivery_service_prices
  end
  resources :tax_rates
  resources :users
  resources :countries
  resources :attachments, only: :destroy

  get 'settings' => 'settings#edit'
  post 'settings' => 'settings#update'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'

  get 'login/reset' => 'password_resets#new'
  post 'login/reset' => 'password_resets#create'

  delete 'logout' => 'sessions#destroy'
  root to: 'dashboard#home'

  namespace :api do
    resources :test do
      get '/' => 'api_test#index'
    end
    resources :products do
      member do
        post 'buy'
      end
    end
    resources :orders do
      collection do
        get 'current'
        post 'current/reset' => 'orders#current_reset'
      end
      member do
        patch 'confirming'
        post 'confirm'
      end
    end
    resources :countries do
    end
  end
end
