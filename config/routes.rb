Ioccp::Application.routes.draw do
  get 'adduser', to: 'users#new', as: 'adduser'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users
  resources :sessions
 
  post '/agent/configure', to: 'agent#configure'
  get '/agent/settings', to: 'agent#settings'
  post '/agent/save', to: 'agent#save'
  
  root to: 'main#index'

end
