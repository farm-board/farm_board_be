Rails.application.routes.draw do
  get 'current_user', to: 'current_user#index'
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' }, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
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
