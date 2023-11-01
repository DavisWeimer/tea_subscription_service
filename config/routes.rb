# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :subscriptions, only: [:create, :destroy, :index]
    end
  end
end
