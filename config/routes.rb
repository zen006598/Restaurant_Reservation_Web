Rails.application.routes.draw do
  root 'restaurants#index'
  devise_for :users, controllers: {registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks'}
  namespace :admin do
    resources :users, only: %i[show] do
      member do
        post :assign_restaurants
      end
    end
    resources :restaurants do
      resources :time_modules, shallow: true, only: %i[create update destroy]
      resources :off_days, shallow: true, only: %i[create update destroy]
      member do
        patch :off_day_setting
        get :setting
      end
    end
  end
  resources :restaurants, only: %i[index show]
end
