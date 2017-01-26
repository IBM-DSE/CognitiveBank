Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root 'cognitive_bank#index'
  get '/offers', to: 'cognitive_bank#offers'
  
end
