Rails.application.routes.draw do
  
  resources :accounts do
     collection { post :import }
    collection { get :import }
    collection { post :batch_download}
  end

  resources :users
 
  post 'api/update_account'
  post 'api/upload_phone'
  


  post "api/upload_mail_for_new_account"
  post "api/get_one_mail_to_register"
  post "api/upload_register_result"
  post "api/get_one_mail_to_activate"
  post "api/upload_activate_result"

  
  root :to => "sessions#new"
 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/signup' => 'users#new'
  post '/users' => 'users#create'
  
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

end
