IdeaMapr::Application.routes.draw do
  # Logins and Profiles
  devise_for :users
  resources :users, path: 'profiles'

  root to: 'homepage#show' # Change this to something else in your app.

  authenticate :admin, lambda { |u| u.is_a? Admin } do
    # Adds RailsAdmin
    mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'
  end
  # Need a catch all to redirect to the errors controller, for catching 404s as an exception
  match "*path", to: "errors#catch_404", via: [:get, :post]
end
