Rails.application.routes.draw do
  root "static#home"

  resources :emails, except: [:destroy, :edit]
  resources :service_addresses, except: [:show, :index]
  resources :stripe_cards, path: :billing

  scope :webhooks do
    post :email, controller: :webhooks
  end

  namespace :admin do
    # resources :users
    resources :service_addresses
    resources :service_jobs
  end

  devise_for :users, path: :account, path_names: { sign_in: "login", sign_out: "logout" }, skip: [:confirmations], controllers: {
    # confirmations: "devise/user/confirmations",
    # omniauth_callbacks: "devise/user/omniauth_callbacks",
    passwords: "devise/user/passwords",
    registrations: "devise/user/registrations",
    sessions: "devise/user/sessions",
    unlocks: "devise/user/unlocks"
  }
  resource :account, controller: :account, only: [ :show, :edit, :update ]

  get :flash_message, controller: :application
end
