IdeaMapr::Application.routes.draw do
  devise_for :admins, only: [:sessions, :passwords]
  devise_for :users, only: :sessions
  
  resources :users, path: 'profiles'

  resources :ideas
  resources :survey_questions, except: [:new, :create]
  
  resources :surveys, only: [:show, :index, :update, :edit] do
    member do
      get '/public_show/:token', action: 'public_show'
    end
    collection do
      post '/update', action: 'update'
    end
  end
  post '/ajax_api' => 'ajax#multiplex'
  get '/ajax_api' => 'ajax#multiplex'
  
  root to: 'dashboard#show' # Change this to something else in your app.

  # Adds RailsAdmin
  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'

  # Need a catch all to redirect to the errors controller, for catching 404s as an exception
  match "*path", to: "errors#catch_404", via: [:get, :post]
end
