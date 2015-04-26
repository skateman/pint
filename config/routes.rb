Rails.application.routes.draw do
  root :to => 'home#index'
  get '/client', :to => 'home#client'
  resources :sessions, :except => [:edit, :new], :defaults => { :format => 'json' } do
    post '/answer', :on => :member, :to => 'sessions#answer'
  end
  resources :presentations, :except => [:edit, :new], :defaults => { :format => 'json' } do
    resources :questions, :except => [:edit, :new]
  end
end
