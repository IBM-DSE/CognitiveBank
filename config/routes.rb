Rails.application.routes.draw do
  
  root 'cognitive_bank#home'
  get 'offers', to: 'cognitive_bank#offers'

  get 'admin', to: 'users#admin'
  get 'admin/profile/:id', to: 'customers#profile', as: 'customer_profile'
  
  scope '/admin' do
    resources :ml_scoring_services do
      collection do
        get 'detect'
      end
    end
    
    resources :customers, only: [:edit, :update]

    resources :transactions, only: :index do
      collection do
        post 'detect_fraud'
      end
    end
  end

  get 'dashboard', to: 'customers#dashboard'
  get 'profile', to: 'customers#profile'
  post 'messages', to: 'messages#create'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
end
