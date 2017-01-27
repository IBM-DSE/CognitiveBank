Rails.application.routes.draw do
  root 'cognitive_bank#home'
  get '/offers', to: 'cognitive_bank#offers'
  get '/profile', to: 'users#profile'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
