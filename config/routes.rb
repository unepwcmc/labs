Labs::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:registrations, :sessions, :passwords]
  devise_scope :user do
    delete '/users/sign_out', to: 'devise/sessions#destroy', as: 'destroy_user_session'
  end

  get 'test_exception_notifier', controller: :application, action: :test_exception_notifier

  resources :users, :only => [:index] do
    member do
      patch :suspend
    end
  end

  namespace :api do
    namespace :v1 do
      post '/projects_domains/upload_model', to: 'projects_domains#upload_model', as: 'upload_model'
    end
  end

  get '/projects/sync', to: 'github_sync#index', as: 'sync_projects'
  post '/projects/sync', to: 'github_sync#sync'
  post '/projects/push_event_webhook', to: 'github_sync#push_event_webhook', as: 'push_event_webhook'

  resources :reviews do
    resources :comments
    resources :review_answers, only: [:show]
    post '/answers', to: 'review_answers#create_or_update'
  end

  resources :projects do
    resources :comments
    collection do
      get :list
    end
  end

  resources :installations do
    resources :comments
    collection do
      put :soft_delete
      get :deleted_list
      put :restore
    end
  end

  resources :servers do
    resources :comments
    collection do
      put :soft_delete
      get :deleted_list
      put :restore
    end
  end

  resources :comments do
  end

  resources :dependencies do
    resources :comments
  end

  get '/project_instances/nagios_list', to: 'project_instances#nagios_list', as: 'nagios_list'

  resources :project_instances do
    resources :comments
    collection do
      put :soft_delete
      get :deleted_list
      put :restore
    end
  end

  resources :domains do
    get '/select_model', to: 'domains#select_model', as: 'select_model'
  end

  get '/contact', :to => 'home#contact'
  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'projects#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
