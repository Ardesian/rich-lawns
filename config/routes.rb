Rails.application.routes.draw do
  devise_for :users
  root "static#home"

  resources :emails, except: [:destroy, :edit]

  scope :webhooks do
    post :email, controller: :webhooks
  end
end
