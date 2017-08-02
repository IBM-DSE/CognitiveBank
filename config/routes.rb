Rails.application.routes.draw do
  
  root 'cognitive_bank#home'
  get 'offers', to: 'cognitive_bank#offers'

  get 'admin', to: 'users#admin'

  get 'dashboard', to: 'customers#dashboard'
  get 'profile', to: 'customers#profile'
  post 'messages', to: 'messages#create'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
end
