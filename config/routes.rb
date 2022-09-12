Rails.application.routes.draw do
  root "posts#index"

  devise_for :users
  resources :users, only: [:index, :show] do
    resource :profile, only: [:show, :edit, :update]
  end
  resources :friendships, only: [:create, :update, :destroy]
  resources :posts, only: [:index, :show, :create]
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create]
end
