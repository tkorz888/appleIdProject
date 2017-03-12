Rails.application.routes.draw do
  
  
  resources :accounts
  resources :users
  root :to => "sessions#new"
 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  


  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
end
