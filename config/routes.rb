Rails.application.routes.draw do
  
  root 'cognitive_bank#home'
  get 'offers', to: 'cognitive_bank#offers'
  
  get 'profile', to: 'customers#profile'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  post 'messages', to: 'messages#create'
end
