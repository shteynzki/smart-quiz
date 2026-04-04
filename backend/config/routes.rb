Rails.application.routes.draw do
  api_base = ENV.fetch("RAILS_API", "/api/v1")
  mount Rswag::Ui::Engine => "#{api_base}/api-docs"
  mount Rswag::Api::Engine => "#{api_base}/api-docs"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :leads, only: [ :create, :index ] do
        member do
          post :confirm_email
        end
      end
      post "telegram/webhook", to: "telegram#webhook"
      post "chat", to: "chat#create"
      post "analytics", to: "analytics#create"
    end
  end
end
