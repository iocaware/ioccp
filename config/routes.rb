Ioccp::Application.routes.draw do
  get 'adduser', to: 'users#new', as: 'adduser'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users
  resources :sessions
 
  # api posts
  post '/agent/configure', to: 'agent#configure'
  post '/agent/register/:agent_id', to: 'agent#register'
  post '/agent/publickey/:agent_id', to: 'agent#get_public_key'

  # agent pages
  get '/agent/settings', to: 'agent#settings'
  post '/agent/save', to: 'agent#save'

  root to: 'main#index'

end
