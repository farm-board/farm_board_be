Rails.application.routes.draw do
  get 'current_user', to: 'current_user#index'
  patch 'current_user/update', to: 'current_user#update'
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'signup' }, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }
  namespace :api do
    namespace :v1 do
      resources :users do
        resource :farms do
          member do
            get 'image', to: 'farms#show_image'
            get 'gallery_photos', to: 'farms#gallery_photos'
          end
          post 'upload_image', to: 'farms#upload_image'
          post 'upload_gallery_photo', to: 'farms#upload_gallery_photo'
          put 'update_gallery_photo', to: 'farms#update_gallery_photo'
          delete 'delete_image', to: 'farms#delete_image'
          delete 'delete_gallery_photo', to: 'farms#delete_gallery_photo'
          resources :postings
          resource :accommodation
        end
        resource :employees do
          member do
            get 'image', to: 'employees#show_image'
          end
          post 'upload_image', to: 'employees#upload_image'
          resources :experiences
          resources :references
        end
      end
    end
  end
end
