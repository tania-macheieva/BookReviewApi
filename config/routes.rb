Rails.application.routes.draw do
  root "books#index"

  resources :books do
    resources :reviews, only: [:index, :create, :update, :destroy], shallow: true
  end

  post "/register", to: "auth#register"
  post "/login", to: "auth#login"
end
