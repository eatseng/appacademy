Tasks::Application.routes.draw do
  get "goals/completed", :to => "goals#completed", :as => "completed_goals"
  get "goals/feed", :to => "goals#feed", :as => "feed"
  get "goals/cheers", :to => "goals#cheers", :as => "cheers"
  resources :users, :goals
  resource :session
end
