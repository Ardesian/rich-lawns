Rails.application.routes.draw do
  root "static#home"

  resources :emails, except: [:destroy, :edit]

  scope :webhooks do
    post :email, controller: :webhooks
  end
end
