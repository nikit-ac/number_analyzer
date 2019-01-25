# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    post 'user_token' => 'user_token#create'
    resources :users, only: :create
    get 'analyzer/index' => 'analyzer#index'
  end
  root 'main#index'
end
