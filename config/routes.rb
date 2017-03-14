Rails.application.routes.draw do
  
  get 'ml_scoring_service/index'

  root 'cognitive_bank#home'
  get 'offers', to: 'cognitive_bank#offers'

  get 'admin', to: 'users#admin'

  get 'dashboard', to: 'customers#dashboard'
  get 'profile', to: 'customers#profile'
  get 'messages', to: 'messages#start'
  post 'messages', to: 'messages#create'
  delete 'customer/:id/messages', to: 'customers#clear_messages', as: 'customer'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
end
