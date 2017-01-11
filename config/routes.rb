Rails.application.routes.draw do
  namespace :api do
    controller :webhooks, as: :webhook, path: :webhooks do
      post :github_callback
    end
  end
end
