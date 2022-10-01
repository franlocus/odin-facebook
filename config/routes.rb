Rails.application.routes.draw do
  authenticated :user do
    root :to => "posts#index"
  end
  unauthenticated :user do
    devise_scope :user do
      get "/" => "devise/sessions#new"
    end
  end
  devise_for :users
  resources :users, only: [:index, :show] do
    resource :profile, only: [:show, :edit, :update]
  end
  resources :friendships, only: [:create, :update, :destroy]
  resources :posts, only: [:index, :show, :create, :destroy]
  resources :likes, only: [:create, :destroy]
  resources :comments, only: [:create, :destroy]
end
