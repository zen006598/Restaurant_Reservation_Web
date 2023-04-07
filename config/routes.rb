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
      resources :seat_modules, shallow: true do
        member do
          post :edit
        end

        resources :seats, shallow: true, only: %i[create update destroy edit new] do
          member do
            post :edit
            post :close
          end
        end
      end
      resources :time_modules, shallow: true, only: %i[create update destroy edit] do
        member do
          post :edit
        end
      end
      resources :off_days, shallow: true, only: %i[destroy]
      member do
        patch :off_day_setting
        get :setting
      end
    end
  end
  
  resources :restaurants, only: %i[index show] do
    member do
      post :get_business_times
      post :get_available_seat
      post :get_unavailable_time
    end
    resources :reservations, shallow: true, only: %i[create new show update edit]
  end
end
