SecretsApp::Application.routes.draw do
  resources :users, :only => [:create, :new, :show, :index] do 
    resource :secrets, :only => [:new]
  end
  resource :session, :only => [:create, :destroy, :new]
  resource :secrets, :only => [:create]
  resource :friendships, :only => [:create, :destroy]

  root :to => "users#show"

end
