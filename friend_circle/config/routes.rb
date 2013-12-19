Social::Application.routes.draw do
  get "users/reset_password", :to => "users#request_password_form", :as => "reset_password"
  post "users/reset_password", :to => "users#receive_request_form", :as => "reset_password"
  get "users/set_new_password", :to => "users#set_new_password", :as => "set_new_password"
  post "users/set_new_password", :to => "users#record_new_password", :as => "set_new_password"
  get "feed", :to => "friend_circles#feed", :as => "feed"

  resources :users, :friend_circles
  resource :session, :only => [:new, :create, :destroy]

  resources :posts do
    resources :links, :only => [:new, :create, :destroy]
  end
end
