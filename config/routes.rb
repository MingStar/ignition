Ignition::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "projects#index"
  
  resources :projects, :pledges, :users, :comments

end
