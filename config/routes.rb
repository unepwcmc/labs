Labs::Application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:registrations, :sessions, :passwords]
  devise_scope :user do
    delete '/users/sign_out', to: 'devise/sessions#destroy', as: 'destroy_user_session'
  end

  resources :users, :only => [:index] do
    member do
      post :suspend
    end
  end

  get '/projects/sync', to: 'github_sync#index', as: 'sync_projects'
  post '/projects/sync', to: 'github_sync#sync'

  resources :projects do
    resources :comments
    collection do
      get :list
    end
  end

  resources :installations do
    resources :comments
  end

  resources :servers do
    resources :comments
  end

  resources :comments do
  end

  resources :dependencies do
    resources :comments
  end

  resources :project_instances do
    resources :comments
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
