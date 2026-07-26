Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  if ENV["APP_DOCUMENT"].present?
    mount Rswag::Ui::Engine => "/docs"
    mount Rswag::Api::Engine => "/docs"
  end

  get "up", to: "rails/health#show", as: :rails_health_check

  get "blobs/:signed_id" => "active_storage/blobs/redirect#show", as: :blob

  if Rails.application.config.active_storage.service.in?(%i[local test])
    get "disk/:encoded_key/*filename" => "active_storage/disk#show", as: :rails_disk_service
  end

  root "home#index"

  # Web authentication with GitHub
  devise_for :users,
             singular: :user,
             only: %i[sessions omniauth_callbacks],
             controllers: {
               sessions: "users/sessions",
               omniauth_callbacks: "users/omniauth_callbacks"
             }

  scope module: :web do

    get "dashboard", to: "dashboard#index"

    resources :repositories, only: %i[index show]

    resources :reviews, only: %i[index show]

    resource :settings, only: :show

    namespace :admin do
      root "dashboard#index"
      resources :users, only: :index
    end
  end 

  namespace :api do
    namespace :v1 do
      namespace :auth do
        devise_scope :user do
          post :sign_up, to: "registrations#create"
          post :sign_in, to: "sessions#create"
          delete :sign_out, to: "sessions#destroy"

          resource :confirmation, only: %i[create update]

          resource :password, only: %i[create update]
        end

        resource :profile, only: %i[show update]
      end

      resources :blobs, param: :signed_id, only: %i[create show]
    end
  end
end