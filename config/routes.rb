Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'companies#index'

  resources :working_times, except: %i[index create] do
    collection do
      post :import_excel
      delete :destroy_all
      put :apply_rate
      get :export_origin
      get :export_salary

      get ':wkt_uuid/list_users', to: 'working_times#list_users', as: 'list_users'
    end

    member do
      put :assign_users
    end
  end

  resources :companies do
    collection do
      get :list_company

      get ':company_id/working_times', to: 'working_times#index', as: 'working_times'
    end

    member do
      delete :kick_user
      get :users_has_not_join
      post :add_users
    end
  end

  resources :users do
    member do
      get :not_join_companies
      post :join_companies
      get :popup_user_rate
    end
  end

  resources :rates
end
