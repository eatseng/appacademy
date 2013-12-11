ContactsApp::Application.routes.draw do
  # resources :users
  get '/users(.:format)', :to => 'users#index'
  get '/users/new(.:format)', :to => 'users#new'
  get '/users/:id/edit(.:format)', :to => 'users#edit'
  get '/users/:id(.:format)', :to => 'users#show'

  post '/users(.:format)', :to => 'users#create'
  put '/users/:id(.:format)', :to => 'users#update'
  delete '/users/:id(.:format)', :to => 'users#destroy'



  resources :contacts, :only => [:show, :create, :update, :destroy]
  resources :contact_shares, :only => [:index, :create, :destroy]

  resources :users do

    get '/fav_contacts', :to => 'contacts#fav_contacts'
    get '/group_contacts', :to => 'contacts#group_contacts'

    resources :contacts, :only => [:index, :show] do
      get '/comments', :to => 'contacts#comments'
    end

  end

end
