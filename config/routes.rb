Ioccp::Application.routes.draw do
  get 'adduser', to: 'users#new', as: 'adduser'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users
  resources :sessions
 
  post '/ioc/add', to: 'ioc#add'
  post '/ioc/delete', to: 'ioc#delete'

  post '/job/add', to: 'job#add'
  post '/job/delete', to: 'job#delete'
  
  # api posts
  post '/agent/configure', to: 'agent#configure'
  post '/agent/register/:agent_id', to: 'agent#register'
  post '/agent/publickey/:agent_id', to: 'agent#get_public_key'
  post '/agent/check/:agent_id', to: 'agent#check'
  post '/ioc/get/:ioc_id', to: 'ioc#get'
  post '/job/confirm/:job_id/:agent_id', to: 'job#confirm'
  # api get
  get '/agent/agentnumbers', to: 'agent#agentnumbers'
  get '/agent/osnumbers', to: 'agent#osnumbers'
  get '/job/status/:job_id', to: 'job#status'
  
  # agent pages
  get '/agent/settings', to: 'agent#settings'
  post '/agent/save', to: 'agent#save'

  root to: 'main#index'

end
