Rails.application.routes.draw do
  namespace :api do
    scope :webhooks, controller: :webhooks, as: :webhooks do
      post :github_callback
    end
  end
end
