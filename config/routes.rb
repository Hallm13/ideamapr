IdeaMapr::Application.routes.draw do
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  devise_for :admins, only: [:sessions, :passwords]
  
  resources :users, path: 'profiles'

  get '/public_info/double_bundle' => 'public_info#double_bundle'

  resources :respondents, only: [] do
    collection do
      get :reset
    end
  end
      
  resources :individual_answers, only: [:create, :update]
  resources :ideas
  resources :survey_questions
  resources :question_details, only: [:index, :create]

  resources :surveys do
    collection do
      post '/update', action: 'update'
      get '/public_show/:public_link', action: 'public_show', as: 'public_show'
    end
    member do
      get '/report', action: 'report'
    end
  end
  
  post '/ajax_api' => 'ajax#multiplex'
  get '/ajax_api' => 'ajax#multiplex'
  
  root to: 'ideas#index'

  # Adds RailsAdmin
  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'

  # Need a catch all to redirect to the errors controller, for catching 404s as an exception
  match "*path", to: "errors#catch_404", via: [:get, :post]
end
