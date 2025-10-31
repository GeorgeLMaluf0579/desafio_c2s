require "sidekiq/web"

Rails.application.routes.draw do\
  # Defines the root path route ("/")
  root "home#index"
  resources :customers, only: %i[ index ]

  resources :uploaded_emails, only: %i[ index new create ]

  mount Sidekiq::Web => "/sidekiq"
end
