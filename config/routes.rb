Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :farms do
        resources :postings
        resource :accommodation
      end
      resources :employees do
        resources :experiences
        resources :references
      end
    end
  end
end
