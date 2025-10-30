Rails.application.routes.draw do
  # Defines the root path route ("/")
  root "home#index"
  resources :customers, only: %i[ index ]
end
