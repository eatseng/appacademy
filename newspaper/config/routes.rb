Social::Application.routes.draw do
  get "users/subscription", :to => "users#view_subscription", :as => "sub"
  post "users/subscription", :to => "users#add_subscription", :as => "sub"
  resources :users
  resource :session, :only => [:new, :create, :destroy]
  resources :newspapers do 
    resources :subscription_plans, :only => [:index, :new, :create, :destroy]
  end

  resources :subscriptions, :only => [:destroy]
end
