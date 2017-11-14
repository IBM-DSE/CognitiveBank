Rails.application.routes.draw do
  
  root 'cognitive_bank#home'
  get 'offers', to: 'cognitive_bank#offers'

  get 'admin', to: 'users#admin'
  
  scope '/admin' do
    resources :ml_scoring_services do
      collection do
        get 'detect'
      end
    end
    
    resources :customers

    resources :transactions, only: :index do
      collection do
        post 'detect_fraud'
      end
    end
  end

  get 'dashboard', to: 'customers#dashboard'
  get 'profile', to: 'customers#show'
  post 'messages', to: 'messages#create'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
end
