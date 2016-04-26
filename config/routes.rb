IdeaMapr::Application.routes.draw do
  devise_for :admins, only: [:sessions, :passwords]
  devise_for :users, only: :sessions
  
  resources :users, path: 'profiles'

  resources :ideas
  resources :survey_responses, only: [:update]
  resources :survey_questions, except: [:new, :create]

  resources :surveys, only: [:show, :index, :update, :edit] do
    collection do
      post '/update', action: 'update'
    end
  end
  resource :survey do
    get '/public_show/:public_link', action: 'public_show', as: 'public_show'
  end
  post '/ajax_api' => 'ajax#multiplex'
  get '/ajax_api' => 'ajax#multiplex'
  
  root to: 'ideas#index' # Change this to something else in your app.

  # Adds RailsAdmin
  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'

  # Need a catch all to redirect to the errors controller, for catching 404s as an exception
  match "*path", to: "errors#catch_404", via: [:get, :post]
end
