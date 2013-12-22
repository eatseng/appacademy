Reddit::Application.routes.draw do
  resources :users, :subs
  resources :links do
    get "upvotes", :to => "links#upvotes", :as => "upvotes"
    get "downvotes", :to => "links#downvotes", :as => "downvotes"
    resources :comments, :only => [:show, :new, :create, :destroy]
  end
  resource :session
end
