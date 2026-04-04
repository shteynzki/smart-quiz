Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api/v1/api-docs"
  mount Rswag::Api::Engine => "/api/v1/api-docs"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    namespace :v1 do
      resources :leads, only: [ :create, :index ]
      post 'telegram/webhook', to: 'telegram#webhook'
      post 'chat', to: 'chat#create'
      post 'analytics', to: 'analytics#create'
    end
  end
end
