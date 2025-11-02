require "sidekiq/web"

Rails.application.routes.draw do\
  # Defines the root path route ("/")
  root "home#index"
  resources :customers, only: %i[ index ]

  resources :uploaded_emails, only: %i[ index new create show ] do
    post :reprocess, on: :member
  end

  resources :email_parser_logs, only: %i[ index ]

  mount Sidekiq::Web => "/sidekiq"
end
