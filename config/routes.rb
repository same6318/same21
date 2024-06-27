Rails.application.routes.draw do
  resources :tasks
  root to: "tasks#index"

  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  namespace :admin do
    resources :users
  end #/users/new(一般ユーザの画面) /admin/users/new（管理者の登録画面）
  resources :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
