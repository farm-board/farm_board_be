Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :farms do
        resource :accommodation
      end
      resources :employees
    end
  end
end
